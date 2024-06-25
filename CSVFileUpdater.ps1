$Folder = '/Users/conrad.gauntlett/WorkArea/CSV/Updated'

function format-CSVFiles {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true)]
        [string]$Folder
        
    )
    
    begin {

        #$Regex          = '(?<LastComma>,)(?<lastdigit>[^,]*)$'
        $Regex          ='(?<LastComma>,)(?<Digits>\d+)$'
        $Results        = @()
        $CSVFiles       = Get-ChildItem -Path $Folder -Filter '*.csv'
        
    }
    
    process {

        foreach ($CSVFile in $CSVFiles) {

            $UpdateCommaCount       = 0
            $UpdateSemicolonCount   = 0
            $CSVContentUpdated      = @()
            $CSVContent             = Get-Content -Path $CSVFile

            # -------------------------------------------------------------------------------------------------------------------------------------------------- #
            
            $CSVContent | ForEach-Object {

                $Row = $_
                
                # --------------------------------------------------------- Replace last comma with a period ------------------------------------------------------- #

                $SearchResult = ($Row | Select-String -Pattern $Regex).Matches.Groups | Where-Object { $_.Name -eq 'LastComma' }
                if ($SearchResult) {

                    $Row                = $Row -replace $SearchResult.Value , '.'
                    $UpdateCommaCount   = $UpdateCommaCount + 1

                } 
                
                # --------------------------------------------------------- Replace semi-colon with a comma -------------------------------------------------------- #
                
                if ($Row.Contains(';')) {
                    
                    $UpdateSemicolonCount   = $UpdateSemicolonCount + (($Row | Select-String -Pattern '(?<semicolon>;)').Matches.Groups | Measure-Object).Count
                    $Row                    = $Row -replace ';' , ','
                    
                }
            
                # -------------------------------------------------------------------------------------------------------------------------------------------------- #

                $CSVContentUpdated += $Row
            } 

            # -------------------------------------------------------------------------------------------------------------------------------------------------- #
            
            Set-Content -Path $CSVFile -Value $CSVContentUpdated -Force

            $Res = [PSCustomObject]@{

                FileName            = $CSVFile.Name
                SemiColonUpdates    = $UpdateSemicolonCount
                CommaUpdates        = $UpdateCommaCount

            }
            $Results += $Res

            # -------------------------------------------------------------------------------------------------------------------------------------------------- #
            
        }
        
    }
    
    end {

        $Results
        
    }
}

$Results = format-CSVFiles $Folder
$Results | Format-Table -AutoSize
