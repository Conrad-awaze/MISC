Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
# https://www.reddit.com/r/bashonubuntuonwindows/comments/ekjdf5/please_enable_the_virtual_machine_platform/
wsl --install -d ubuntu

sudo apt update
sudo apt --upgradeable
sudo apt upgrade



choco install todobackup -y
choco install googlechrome -y
# choco uninstall googlechrome -y
choco install steam-client -y
choco install epicgameslauncher -y
choco install vmware-workstation-player -y
# choco install nvidia-geforce-now -y
choco install geforce-experience -y
choco install sidequest -y
choco install powershell-core -y
choco install vscode -y
# choco install vscode-powershell -y
choco install sharex -y
choco install firefox -y
choco install ipvanish -y
choco install git -y
choco install python -y

choco install azure-data-studio -y
choco install azuredatastudio-powershell -y
choco install sql-server-management-studio -y

winget install '1password' --accept-package-agreements --accept-source-agreements
winget install 'Microsoft PowerToys' --accept-package-agreements --accept-source-agreements
winget install 'Logitech G HUB' --accept-package-agreements --accept-source-agreements
winget install 'Sky Go' --accept-package-agreements --accept-source-agreements
winget install 'VLC media player' --accept-package-agreements --accept-source-agreements
winget install --id 'Git.Git' --accept-package-agreements --accept-source-agreements
winget install 'VeraCrypt' --accept-package-agreements --accept-source-agreements

<#
E:\Downloads\2022\OculusSetup.exe /drive=E

To install the Oculus app on a different system drive:
Press the Windows key + R to open the Run command.
Enter the following path: [drive]:\Users\(Username)\Downloads\OculusSetup.exe/drive=[new system drive] 
Replace [drive] with the letter of the drive where Oculus was downloaded to. ...
Click OK.
#>

<#
winget install 'Google Chrome' --accept-package-agreements --accept-source-agreements
winget install '1password' --accept-package-agreements --accept-source-agreements
winget install 'Microsoft PowerToys' --accept-package-agreements --accept-source-agreements
winget install 'Epic Games Launcher' --accept-package-agreements --accept-source-agreements
# winget install 'VMware Player' --accept-package-agreements --accept-source-agreements
winget install 'NVIDIA GeForce Experience' --accept-package-agreements --accept-source-agreements
winget install 'Logitech G HUB' --accept-package-agreements --accept-source-agreements
winget install 'Sky Go' --accept-package-agreements --accept-source-agreements
winget install 'VLC media player' --accept-package-agreements --accept-source-agreements
winget install --id 'Audacity.Audacity' --accept-package-agreements --accept-source-agreements

winget install --id 'Microsoft.AzureDataStudio' --accept-package-agreements --accept-source-agreements
winget install --id 'Microsoft.VisualStudioCode' --accept-package-agreements --accept-source-agreements
winget install --id 'Git.Git' --accept-package-agreements --accept-source-agreements
winget install 'VeraCrypt' --accept-package-agreements --accept-source-agreements
winget install --id 'JAMSoftware.TreeSize.Free' --accept-package-agreements --accept-source-agreements

winget install --id 'Microsoft.SQLServerManagementStudio' --accept-package-agreements --accept-source-agreements
winget install 'SideQuest' --accept-package-agreements --accept-source-agreements
winget install --id 'Mozilla.Firefox' --accept-package-agreements --accept-source-agreements
winget install --id 'Apple.iTunes' --accept-package-agreements --accept-source-agreements
winget install --id 'Docker.DockerDesktop' --accept-package-agreements --accept-source-agreements
winget install --id 'ShareX.ShareX' --accept-package-agreements --accept-source-agreements

<#
E:\Downloads\2022\OculusSetup.exe /drive=E

To install the Oculus app on a different system drive:
Press the Windows key + R to open the Run command.
Enter the following path: [drive]:\Users\(Username)\Downloads\OculusSetup.exe/drive=[new system drive] 
Replace [drive] with the letter of the drive where Oculus was downloaded to. ...
Click OK.
#>


winget search 'ShareX' #--id 'Microsoft.AzureDataStudio'

winget search --id 'VS Code'
winget uninstall 'Docker.DockerDesktop'
winget uninstall 'Apple.iTunes'

#>
