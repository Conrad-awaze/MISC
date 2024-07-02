Import-Module dbatools, PSTimers

$CSVFile        = 'P:\DBA\Installments\instalments_dedupe.csv'
$CSVFileExport  = "P:\DBA\Installments\logs\PlansExport_$(get-date -format "yyyy-MM-dd HH-mm-ss").csv"
$SQLInstance    = 'WERCOVRDEVSQLD1,2533'
$Database       = 'TR4_DEV'
$Bookings       = Import-Csv -Path $CSVFile
$Results        = @()
$Count          = 0
$Timer          = "Process"
# $PlanMessage    = "Please note, this booking has been amended retrospectively to include an instalment plan. This had to be made, due to a technical error at the time of booking. For this reason you may see chronological discrepancies in the audit log."

Start-MyTimer -Name $Timer
foreach ($Booking in $Bookings) {

    $Count++

    $ScriptCheck    = "EXEC thg_getFeatureValues @BookingIds=$($Booking.BOOKING_ID)"
    $Check          = Invoke-DbaQuery -SqlInstance $SQLInstance -Database $Database -Query $ScriptCheck -As PSObject

    switch ([string]::IsNullOrEmpty($Check)) {

        True { 

            $CountNoResults = $CountNoResults + 1
            Write-Host "Booking ID: $($Booking.BOOKING_ID) - No Result Set"

            $Res = [PSCustomObject]@{

                Number      = $Count
                Booking_ID  = $($Booking.BOOKING_ID)
                Start_Date  = $($Booking.START_DATE)
                Check       = 'No Result Set'
                Recheck     = 'N/A'

            }
            $Results += $Res
            $Res | Export-Csv -Path $CSVFileExport -NoTypeInformation -Append
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

                $Res = [PSCustomObject]@{
                    Number      = $Count
                    Booking_ID  = $($Booking.BOOKING_ID)
                    Start_Date  = $($Booking.START_DATE)
                    Check       = 'NoPlan'
                    Recheck     = "N/A"
                }
                $Results += $Res
                $Res  | Export-Csv -Path $CSVFileExport -NoTypeInformation -Append


            }
            

        }
    }

}

$DurationComplete = Get-MyTimer -Name $Timer
Remove-MyTimer -Name $Timer

$FinalReport = [PSCustomObject]@{

    Date                    = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Duration                = $($DurationComplete.Duration.ToString("hh\:mm\:ss"))
    'Bookings - Total'        = $Bookings.Count
    'Bookings - No Plan'      = ($Results | Where-Object { $_.Check -eq 'NoPlan' }).Count
    'Bookings - With Plan'    = ($Results | Where-Object { $_.Check -eq 'Plan Already Added' }).Count
    
}

$FinalReport
$FinalReport | Export-Csv -Path "P:\DBA\Installments\logs\Report.csv" -NoTypeInformation -Append


