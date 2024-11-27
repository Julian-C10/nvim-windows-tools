# Get the current directory
$currentDir = Get-Location

# Get all directories containing .exe files recursively
$exeDirectories = Get-ChildItem -Path $currentDir -Recurse -Filter *.exe | 
                  Select-Object -ExpandProperty DirectoryName -Unique

# Retrieve the current user PATH environment variable without expanding variables
$currentPath = (Get-Item "HKCU:\Environment").GetValue("Path", $null, 'DoNotExpandEnvironmentNames')

foreach ($dir in $exeDirectories) {
    # Check if the directory is already in the PATH
    if (-not ($currentPath -split ';' | Where-Object { $_ -eq $dir })) {
        # Append the new directory to the PATH
        $currentPath += ";$dir"
        
        # Print a message indicating that the path has been added
        Write-Host "Added to user PATH: $dir"
    }
}

# Set the updated PATH variable back to the user environment
Set-ItemProperty -Path "HKCU:\Environment" -Name "Path" -Value $currentPath

Write-Host "Updated user PATH environment variable successfully."

