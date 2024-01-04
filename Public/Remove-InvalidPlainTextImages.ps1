<#
.SYNOPSIS
    Removes image files that are suspected to be plaintext.

.DESCRIPTION
    The Remove-InvalidPlainTextImages function removes image files that are suspected to be plaintext. 
    It reads the content of each file and counts the number of non-printable characters. 
    If the proportion of non-printable characters is below a specified threshold, it assumes the file is plaintext and removes it.
    For SVG files, it checks if the file content contains the "<svg" tag. If not, it assumes the file is not a valid SVG and removes it.

.PARAMETER Files
    The files to be processed. This parameter is mandatory and can accept pipeline input.

.PARAMETER Threshold
    The threshold for the proportion of non-printable characters. If the proportion of non-printable characters in a file is below this threshold, the file is assumed to be plaintext and is removed. The default value is 0.005.

.PARAMETER Filter
    The file extensions to be processed. If set to 'All', all supported image file extensions will be processed. The default value is 'All'.

.PARAMETER MaxThreads
    The maximum number of threads to use for processing the files. The default value is 16.

.EXAMPLE
    Remove-InvalidPlainTextImages -Files $Files -Threshold 0.01 -Filter 'jpg' -MaxThreads 8

    This command removes .jpg files in the $Files array that are suspected to be plaintext. It uses a threshold of 0.01 and a maximum of 8 threads.

.NOTES
    This function uses the ForEach-Object -Parallel cmdlet to process the files in parallel. This cmdlet is available in PowerShell 7 and later.
#>
function Remove-InvalidPlainTextImages {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [System.Object] $Files,
        [double] $Threshold = 0.005,
        [ValidateSet('All','png','jpg','jpeg','gif','bmp','webp','tif','tiff','svg', IgnoreCase = $true)]
        [string] $Filter = 'All',
        [Int32] $MaxThreads = 16
    )

    begin {
        $List = [System.Collections.Generic.List[String]]@()
        if($Filter -eq 'All'){
            Write-Host "Filter is set to process ALL image types." -ForegroundColor White
        } else {
            Write-Host "Filter is set to process $Filter files only." -ForegroundColor White
        }
    }

    process {

        try {
            foreach ($P in $Files) {
                $Path = if ($P -is [String]) { $P }
                        elseif ($P.Path) { $P.Path }
                        elseif ($P.FullName) { $P.FullName }
                        elseif ($P.PSPath) { $P.PSPath }
                        else { Write-Error "$P is an unsupported type."; throw }

                $AbsolutePath = Resolve-Path -Path $Path
                if (Test-Path -Path $AbsolutePath) {
                    $rePattern = if ($Filter -ne 'All') { "\.($Filter)$" } 
                    else { "\.(png|jpg|jpeg|gif|bmp|webp|tif|tiff|svg)$" }
                    if ($AbsolutePath -match $rePattern) {
                        $List.Add($AbsolutePath)
                    }
                } else {
                    Write-Warning "$AbsolutePath does not exist."
                }
            }
        } catch {
            Write-Error "Something went wrong parsing -File. Check your input."
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }

    end {
        
        $List | ForEach-Object -Parallel {
            
            $Image = $_
            $isSVG = "\.(svg)$"

            if($Image -match $isSVG){

                $SVGContents = Get-Content $Image -Raw
            
                if ($SVGContents -notmatch "<svg") {
                    Remove-Item $Image -Force
                    Write-Host "Deleted invalid SVG: $CurrentFile"
                }

            } else {

                try {
                    # Read the file content
                    $content = [System.IO.File]::ReadAllBytes($Image)
        
                    # Count the number of non-printable characters
                    $nonPrintableCount = 0
                    foreach ($byte in $content) {
                        # Check if byte is outside the range of typical printable ASCII characters (space to tilde)
                        if ($byte -lt 32 -or $byte -gt 126) {
                            $nonPrintableCount++
                        }
                    }
        
                    # Calculate the proportion of non-printable characters
                    $nonPrintableProportion = $nonPrintableCount / $content.Length
        
                    # If the proportion of non-printable characters is below the threshold, assume plaintext and remove the file
                    if ($nonPrintableProportion -lt $Using:Threshold) {
                        Remove-Item -Path $Image -Force
                        Write-Host "Deleted invalid image: $Image"
                    }
        
                } catch {
                    Write-Error "An error occurred processing file $Image : $_"
                }
            }

        } -ThrottleLimit $MaxThreads
    }
}