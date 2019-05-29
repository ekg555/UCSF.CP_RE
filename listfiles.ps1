# edited from https://code.adonline.id.au/script-to-list-files-by-type-and-size-export-to-excel/
#         and https://code.adonline.id.au/folder-file-browser-dialogues-powershell/
# ===============================================================================================
# NOTE: FILE WILL APPEAR in the FOLDER/DIRECTORY where this script is RUN.
# ===============================================================================================

# DIALOG BOX for FOLDER-SELECTION
# -----------------------------------------------------------------------------------------------
Write-Host "Select Folder to search & Click OK"

function Find-Folders {
    [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    [System.Windows.Forms.Application]::EnableVisualStyles()
    $browse = New-Object System.Windows.Forms.FolderBrowserDialog
    $browse.SelectedPath = "C:\"
    $browse.ShowNewFolderButton = $false
    $browse.Description = "Select a directory"

    $loop = $true
    while($loop)
    {
        if ($browse.ShowDialog() -eq "OK")
        {
        $loop = $false
		
		#Insert your script here
        $searchDIR = $browse.SelectedPath
        } else
        {
            $res = [System.Windows.Forms.MessageBox]::Show("You clicked Cancel. Would you like to try again or exit?", "Select a location", [System.Windows.Forms.MessageBoxButtons]::RetryCancel)
            if($res -eq "Cancel")
            {
                #Ends script
                exit
            }
        }
    } 
    $searchDIR
    $browse.Dispose()
}

# -----------------------------------------------------------------------------------------------


$searchDIR = Find-Folders
Write-Host "Gathering FileInfo in..." $searchDIR
# $searchDIR = 'P:'							# MANUAL-SELECT
$now = Get-Date -UFormat "%Y-%m-%d.%H%M" 	# TIMESTAMP
$Filenom = 'FileInfo_'+$now+'.csv'			# FILENAME

# For Kicks: Start Time
$T0 = Get-Date -Format g
Write-Host "FileInfo Gathering Started:" $T0

# The "MEAT"
get-childitem $searchDIR -Recurse | where {!$_.PSIsContainer} | select-object FullName, LastWriteTime, Length | export-csv -notypeinformation -path $Filenom | % {$_.Replace('"','')}

# Time!
$Tf = Get-Date -Format g
Write-Host "FileInfo Gathering Completed:" $Tf

#PAUSE.
Write-Host "DONE."
Start-Process -FilePath $Filenom -WindowStyle Maximized  # OPEN FILELIST.
ii .  # OPEN CURRENT DIRECTORY
CMD /c PAUSE
