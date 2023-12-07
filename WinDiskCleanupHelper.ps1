#Requires -Version 7
Param($topNFiles = 100, $target = "C:/")

Function Get-Loader-Text {
    Param($char, $secondsBetween)
    $percentComplete = 0
    $indicator = "$char";

    If ($percentComplete -lt 99)
    {
        while ($percentComplete -gt 0) {
            $indicator += "$char";
            $percentComplete = $percentComplete - 1;
            Write-Output "Loading..."`r`n
            Write-Output $indicator
        }
    }
}

Function Get-Largest-Files {
    param($NLargestFiles, $target) 

    # Get all the files from all the drives and sort them by size in descending order
    Get-ChildItem -Path $target -Recurse -File -ErrorAction SilentlyContinue | Sort-Object Length -Descending | Select-Object -First $topNFiles | ForEach-Object -Parallel {
        $size = $_.Length;    
        $curFile = "$($_.FullName) | $($_.LastAccessTime) | "; 

        If ($size -gt 1GB) {
            $curFile += "{0:N2} GB" -f ($size / 1GB)
        }
        ElseIf ($size -gt 1MB) {
            $curFile += "{0:N2} MB" -f ($size / 1MB)
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
    # can be assigned as in $var = Get-ChildItem 
    Get-ChildItem -Path $target -Recurse -File -ErrorAction SilentlyContinue | Sort-Object Length -Descending | Sort-Object LastAccessTime -Descending | Select-Object -First $topNFiles | ForEach-Object -Parallel {
        $size = $_.Length;    
        $curFile = "$($_.FullName) | $($_.LastAccessTime) | "; 

        If ($size -gt 1GB) {
            $curFile += "{0:N2} GB" -f ($size / 1GB)
        }
        ElseIf ($size -gt 1MB) {
            $curFile += "{0:N2} MB" -f ($size / 1MB)
        }
        ElseIf ($size -gt 1KB) {
            $curFile += "{0:N2} KB" -f ($size / 1KB)
        }
        Else {
            $curFile += "{0:N2} BYTES" -f $size
        }
            
        Write-Host $curFile`r`n`n
    }
}

Write-Host "Searching for the largest $($topNFiles) files starting from $($target)"`r`n
Write-Output 'Getting largest files...'`n 
Write-Output Get-Loader-Text('#', 1)
Get-Largest-Files($topNFiles , $target)
Write-Output "`r`n The most recent  $($topNFiles) files accessed, while searching recursively starting from $($target)"`r`n
Get-Most-Recent($topNFiles , $target)
Write-Output "The most recent $($topNFiles) files touched on disk, recursively starting from $($target)"`r`n
Write-Debug $psversiontable 