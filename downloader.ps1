# TODO: Make the code download 5 files in parallel

# Define the path to your text file
$scannedURLsPath = ".\Scans\http___www.exploremarmaris.com_read_Survival_.txt"
$outputPath = ".\Output"

# Read the content of the text file line by line
$urls = Get-Content $scannedURLsPath

# Loop through each URL and download the file
$jobCount = 0
foreach ($url in $urls) {
    $url = $url.Trim()  # Remove any leading/trailing spaces

    # Extract the filename from the URL
    $fileName = [System.IO.Path]::GetFileName($url)

    # Decode the URL-encoded file name
    $fileName = [System.Web.HttpUtility]::UrlDecode($fileName)

    # Use Start-Job cmdlet to run the download operation in the background
    $job = Start-Job -ScriptBlock {
        param($url, $outputPath, $fileName)
        try {
            Invoke-WebRequest -Uri $url -OutFile (Join-Path -Path $outputPath -ChildPath $fileName) -ErrorAction Stop
            Write-Host "Downloaded $fileName"
        }
        catch {
            $errorMessage = $_.Exception.Message
            Write-Host "Failed to download $fileName. Error: $errorMessage"
            Write-Error $errorMessage  # Add error logging
        }
    } -ArgumentList $url, $outputPath, $fileName

    # Keep track of the number of running jobs
    $jobCount++

    # Wait for the number of running jobs to reach the desired parallelism (5 in this case)
    if ($jobCount -ge 5) {
        # Wait for all jobs to complete before continuing
        Get-Job | Wait-Job | Receive-Job
        $jobCount = 0
    }
}

# Wait for any remaining jobs to complete
Get-Job | Wait-Job | Receive-Job

# Clean up finished jobs
Get-Job | Remove-Job