#Requires -Version 7
Param($topNFiles = 100, $target="C:/")

Function Get-Largest-Files {
    param($NLargestFiles, $target) 

    # Get all the files from all the drives and sort them by size in descending order
    $biggestFiles = Get-ChildItem -Path $target -Recurse -File -ErrorAction SilentlyContinue | Sort-Object Length -Descending | Select-Object -First $topNFiles | ForEach-Object -Parallel {
            $size = $_.Length;    
            $curFile = "$($_.FullName) | $($_.LastAccessTime) | "; 

                If ($size -gt 1GB) {
                    $curFile += "{0:N2} GB" -f ($size / 1GB)
                }
                ElseIf ($size -gt 1MB) {
                    $curFile +="{0:N2} MB" -f ($size / 1MB)
                }
                ElseIf ($size -gt 1KB) {
                    $curFile += "{0:N2} KB" -f ($size / 1KB)
                }
                Else {
                    $curFile += "{0:N2} BYTES" -f $size
                }

            Write-Host $curFile`r`n
            Write-Output $curFile`r`n
    }
}

Function Get-Most-Recent {
    param($NLargestFiles, $target) 

    # Get all the files from all the drives and sort them by size in descending order
    $biggestFiles = Get-ChildItem -Path $target -Recurse -File -ErrorAction SilentlyContinue | Sort-Object Length -Descending | Sort-Object LastAccessTime -Descending | Select-Object -First $topNFiles | ForEach-Object -Parallel {
            $size = $_.Length;    
            $curFile = "$($_.FullName) | $($_.LastAccessTime) | "; 

            If ($size -gt 1GB) {
                $curFile += "{0:N2} GB" -f ($size / 1GB)
            }
            ElseIf ($size -gt 1MB) {
                $curFile +="{0:N2} MB" -f ($size / 1MB)
            }
            ElseIf ($size -gt 1KB) {
                $curFile += "{0:N2} KB" -f ($size / 1KB)
            }
            Else {
                $curFile += "{0:N2} BYTES" -f $size
            }
            
            Write-Host $curFile`r`n`n
            Write-Output $curFile`r`n`n
    }
}

Write-Host "Searching for the largest $($topNFiles) files starting from $($target)"`r`n
Echo 'Getting largest files...'`n 
Get-Largest-Files($topNFiles , $target)
Echo "`r`n The most recent  $($topNFiles) files accessed, while searching recursively starting from $($target)"`r`n
Get-Most-Recent($topNFiles , $target)
Echo "The most recent $($topNFiles) files touched on disk, recursively starting from $($target)"`r`n
Write-Debug $psversiontable 