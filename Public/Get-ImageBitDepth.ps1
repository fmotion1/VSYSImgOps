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
        [string[]]$LiteralPath,

        [Parameter(Mandatory = $false)]
        [Switch]
        $ReturnFullFormat,

        [Parameter(Mandatory = $false)]
        [ValidateSet('None', 'PSObject', 'JSON', 'XML', 'Table', IgnoreCase = $true)]
        [String]
        $OutputFormat = 'None'
    )

    begin {}

    process {
        # Resolve path(s)
        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            $resolvedPaths = Resolve-Path -Path $Path | Select-Object -ExpandProperty Path
        } elseif ($PSCmdlet.ParameterSetName -eq 'LiteralPath') {
            $resolvedPaths = Resolve-Path -LiteralPath $LiteralPath | Select-Object -ExpandProperty Path
        }

        foreach ($item in $resolvedPaths) {
            # # Obtain Bit Depth
            $image = [System.Drawing.Bitmap]::FromFile($item)
            $bitDepth = $image.PixelFormat.ToString()
            $image.Dispose()

            # Assign Bit Depth Variables
            $fullBitDepth = $bitDepth
            if ($bitDepth -match '(\d+)') {
                $shortBitDepth = $Matches[1]
            }

            if ($OutputFormat -eq 'PSObject') {
                if ($ReturnFullFormat) {
                    [PSCustomObject]@{
                        Image    = $item
                        BitDepth = $fullBitDepth
                    }
                } else {
                    [PSCustomObject]@{
                        Image    = $item
                        BitDepth = $shortBitDepth
                    }
                }
            }

            if ($OutputFormat -eq 'None') {
                if ($ReturnFullFormat) {
                    $fullBitDepth
                } else {
                    $shortBitDepth
                }
            }

        }
    }

    end {}
}

