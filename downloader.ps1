# Define the path to your text file
$scannedURLsPath = ".\Scans\http___www.exploremarmaris.com_read_Survival_.txt"
$outputPath = ".\Output"

# Read the content of the text file line by line
$urls = Get-Content $scannedURLsPath

# Loop through each URL and download the file
foreach ($url in $urls) {
    $url = $url.Trim()  # Remove any leading/trailing spaces
    
    # Extract the filename from the URL
    $fileName = [System.IO.Path]::GetFileName($url)
    
    # Decode the URL-encoded file name
    $fileName = [System.Web.HttpUtility]::UrlDecode($fileName)
    
    # Use the Invoke-WebRequest cmdlet to download the file
    try {
        Invoke-WebRequest -Uri $url -OutFile (Join-Path -Path $outputPath -ChildPath $fileName) -ErrorAction Stop
        Write-Host "Downloaded $fileName"
    }
    catch {
        $errorMessage = $_.Exception.Message
        Write-Host "Failed to download $fileName. Error: $errorMessage"
        Write-Error $errorMessage  # Add error logging
    }
    
    Start-Sleep -Seconds 0.1  # Wait for X seconds before the next request
}