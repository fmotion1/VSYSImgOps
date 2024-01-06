

function Get-SvgDimensions {
    param([string]$path)
    $content = Get-Content -Path $path -Raw

    if ($content -match 'viewBox="([^"]+)"') {
        $viewBoxValues = $matches[1].Split(' ')
        $width = $viewBoxValues[2]
        $height = $viewBoxValues[3]
    } elseif ($content -match 'width="([^"]+)"' -and $content -match 'height="([^"]+)"') {
        $width = $matches[1]
        $height = $matches[1]
    } else {
        $width = "Unknown"
        $height = "Unknown"
    }

    return "Width: $width, Height: $height"
}

Get-SvgDimensions "C:\Users\futur\Desktop\Test\Uncropped\Brands Coinbase.svg"
