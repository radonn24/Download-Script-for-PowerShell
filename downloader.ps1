# Prompt the user for a URL
$url = Read-Host "Enter the URL for the file you want to download"

# Validate the URL
if ($url -match '^https?://[^\s/$.?#].[^\s]*$') {
    Write-Host "Valid URL entered: $url"
    # TODO: Add the download logic here
}
else {
    Write-Host "Invalid URL format. Please make sure to include http:// or https://"
}
