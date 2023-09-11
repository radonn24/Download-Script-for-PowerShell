# Prompt the user for a URL
$url = Read-Host "Enter the URL for the file you want to download"

# Validate the URL
if ($url -match '^https?://[^\s/$.?#].[^\s]*$') {
    Write-Host "Valid URL entered: $url"

    # Determine if the URL is a file or a folder
    $response = Invoke-WebRequest -Uri $url -Method Head
    $contentType = $response.Headers["Content-Type"]
    
    if ($contentType -match "text/html") {
        Write-Host "URL points to a folder"
        # Add folder download logic here
    }
    else {
        Write-Host "URL points to a file"
        # Add file download logic here
    }
}
else {
    Write-Host "Invalid URL format. Please make sure to include http:// or https://"
}

# http://www.exploremarmaris.com/read/Survival/