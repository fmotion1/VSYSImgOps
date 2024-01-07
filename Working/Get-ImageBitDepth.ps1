# DONE 1
function Get-ImageBitDepth {
    [cmdletbinding(DefaultParameterSetName = 'Path')]
    param(
        [parameter(
            Mandatory,
            ParameterSetName = 'Path',
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string[]]$Path,

        [parameter(
            Mandatory,
            ParameterSetName = 'LiteralPath',
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('PSPath')]
        [string[]]$LiteralPath
    )

    process {
        # Resolve path(s)
        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            $resolvedPaths = Resolve-Path -Path $Path | Select-Object -ExpandProperty Path
        } elseif ($PSCmdlet.ParameterSetName -eq 'LiteralPath') {
            $resolvedPaths = Resolve-Path -LiteralPath $LiteralPath | Select-Object -ExpandProperty Path
        }

        $PSObjects = @()

        foreach ($item in $resolvedPaths) {

            try {

                $image = [System.Drawing.Bitmap]::FromFile($item)
                $bitDepth = $image.PixelFormat.ToString()
                $image.Dispose()

                $fullBitDepth = $bitDepth
                if ($bitDepth -match '(\d+)') {
                    $shortBitDepth = $Matches[1]
                }

                $PSObj = [PSCustomObject]@{
                    FullBitDepth = $fullBitDepth
                    ShortBitDepth = "$shortBitDepth-Bit"
                    Image = Split-Path $item -Leaf
                    Path = Split-Path $item -Parent
                }

                $PSObjects += $PSObj

            }
            catch {
                Write-Error "A critical error occured: $_"
                $Error[0] | Format-List * -Force
            }
        }

        $PSObjects
    }
}



# $ImageA = "D:\Dev\Powershell\VSYSModules\VSYSImgOps\bin\DomColorsTestImages\TestImg 07.jpg"
# $ImageB = "D:\Dev\Powershell\VSYSModules\VSYSImgOps\bin\DomColorsTestImages\TestImg 02.jpg"
# $ImageC = "D:\Dev\Powershell\VSYSModules\VSYSImgOps\bin\DomColorsTestImages\TestImg 05.jpg"
# Get-ImageBitDepth -Path $ImageA, $ImageB, $ImageC
