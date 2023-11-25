function Get-ImageDimensions {

    [cmdletbinding(DefaultParameterSetName = 'Path')]
    param(
        [parameter(
            Mandatory,
            ParameterSetName  = 'Path',
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

        [Parameter(Mandatory=$false)]
        [Switch]
        $WidthOnly,

        [Parameter(Mandatory=$false)]
        [Switch]
        $HeightOnly,

        [Parameter(Mandatory=$false)]
        [Switch]
        $IncludeImagePath

    )

    begin {
        # Init
    }

    process {

        # Resolve path(s)
        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            $resolvedPaths = Resolve-Path -Path $Path | Select-Object -ExpandProperty Path
        } elseif ($PSCmdlet.ParameterSetName -eq 'LiteralPath') {
            $resolvedPaths = Resolve-Path -LiteralPath $LiteralPath | Select-Object -ExpandProperty Path
        }

        # Process each item in resolved paths
        foreach ($item in $resolvedPaths) {

            $Image = [System.Drawing.Image]::FromFile($item)

            $Width = $Image.Width
            $Height = $Image.Height
            $Image.Dispose()

            if($WidthOnly){ return $Width }
            if($HeightOnly){ return $Height }
            
            $ReturnObject = [PSCustomObject]@{
                Width  = $Width
                Height = $Height
            }

            if($IncludeImagePath){
                $ReturnObject | Add-Member -Name 'Image' -Type NoteProperty -Value $item
            }

            $ReturnObject
        }
    }
}
