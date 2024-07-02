Import-Module dbatools, PSTimers

$CSVFile        = 'F:\temp\Installments\instalments_dedupe.csv'
$CSVFileExport  = "F:\temp\Installments\logs\PlansExport_$(get-date -format "yyyy-MM-dd HH-mm-ss").csv"
$SQLInstance    = 'LONPMSKSQL01'
$Database       = 'TR4_Live_Masked'
$Bookings       = Import-Csv -Path $CSVFile
$Results        = @()
$Count          = 0
$Timer          = "Process"
$PlanMessage    = "Please note, this booking has been amended retrospectively to include an instalment plan. This had to be made, due to a technical error at the time of booking. For this reason you may see chronological discrepancies in the audit log."

Start-MyTimer -Name $Timer
foreach ($Booking in $Bookings) {

    $Count++

    $ScriptCheck    = "EXEC thg_getFeatureValues @BookingIds=$($Booking.BOOKING_ID)"
    $Check          = Invoke-DbaQuery -SqlInstance $SQLInstance -Database $Database -Query $ScriptCheck -As PSObject

    switch ([string]::IsNullOrEmpty($Check)) {

        True { 

            $CountNoResults = $CountNoResults + 1
            Write-Host "Booking ID: $($Booking.BOOKING_ID) - No Result Set"
        }
        False {

            $InstallmentPlan = $Check | Where-Object { $_.FeatureId -eq '13472' }

            if ($InstallmentPlan) {

                Write-Host "Booking ID: $($Booking.BOOKING_ID) - Instalment Plan Already Added"
                
                $Res = [PSCustomObject]@{

                    Number      = $Count
                    Booking_ID = $($Booking.BOOKING_ID)
                    Start_Date = $($Booking.START_DATE)
                    Check = 'Plan Already Added'
                    Recheck = 'N/A'

                }
                $Results += $Res
                $Res | Export-Csv -Path $CSVFileExport -NoTypeInformation -Append

            }else{

                Write-Host "Booking ID: $($Booking.BOOKING_ID) - No Instalment Plan Found"

                $ScriptUpdate   = "EXEC db_FetAdd @LinkID=$($Booking.BOOKING_ID), @Cat=6, @AID=13472, @VID=13473, @UID=1"
                Invoke-DbaQuery -SqlInstance $SQLInstance -Database $Database -Query $ScriptUpdate -As PSObject

                Write-Host "Booking ID: $($Booking.BOOKING_ID) - Plan Added. Rechecking...!!!"

                Start-Sleep 1

                $ReCheck        = Invoke-DbaQuery -SqlInstance $SQLInstance -Database $Database -Query $ScriptCheck -As PSObject

                $InstallmentPlanRecheck = $ReCheck | Where-Object { $_.FeatureId -eq '13472' }

                if ($InstallmentPlanRecheck) {
                    
                    $Res = [PSCustomObject]@{
                        Number      = $Count
                        Booking_ID  = $($Booking.BOOKING_ID)
                        Start_Date  = $($Booking.START_DATE)
                        Check       = 'NoPlan'
                        Recheck     = "Plan Added"
                    }
                    $Results += $Res
                    $Res  | Export-Csv -Path $CSVFileExport -NoTypeInformation -Append

                    Write-Host "Booking ID: $($Booking.BOOKING_ID) - Plan Added Successfully...!!!"

                    start-sleep  1

                    $ScriptAuditLog = "EXEC hosdb_NotesUpd @ID=$($Booking.BOOKING_ID), @Notes='$PlanMessage', @UpdBooking=1, @UpdClient=0, @UpdSupplier=0,@UID=1"
                    $ResultAudit = Invoke-DbaQuery -SqlInstance $SQLInstance -Database $Database -Query $ScriptAuditLog -As PSObject
                    
                    Write-Host "Booking ID: $($Booking.BOOKING_ID) - Audit Log Updated...!!!"

                    start-sleep  1

                    Clear-Host

                }else {
                    
                    $Res = [PSCustomObject]@{
                        Number      = $Count
                        Booking_ID  = $($Booking.BOOKING_ID)
                        Start_Date  = $($Booking.START_DATE)
                        Check       = 'NoPlan'
                        Recheck     = 'Plan Not Added'
                    }
                    $Results += $Res
                    $Res  | Export-Csv -Path $CSVFileExport -NoTypeInformation -Append

                    Write-Host "Booking ID: $($Booking.BOOKING_ID) - Plan NOT Added...!!!"
                }
                

            }
            
            #$Results  | Export-Csv -Path "F:\temp\Installments\logs\NoPlan_$(get-date -format "yyyy-MM-dd HH-mm-ss").csv" -NoTypeInformation -Append
        }
    }

}

$DurationComplete = Get-MyTimer -Name $Timer
Remove-MyTimer -Name $Timer

$FinalReport = [PSCustomObject]@{

    Date            = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Duration        = $($DurationComplete.Duration.ToString("hh\:mm\:ss"))
    TotalBookings   = $Bookings.Count
    NoPlan          = ($Results | Where-Object { $_.Check -eq 'NoPlan' }).Count
    Plan            = ($Results | Where-Object { $_.Check -eq 'Plan Already Added' }).Count
    
}

$FinalReport | Export-Csv -Path "F:\temp\Installments\logs\Report.csv" -NoTypeInformation -Append
$FinalReport

