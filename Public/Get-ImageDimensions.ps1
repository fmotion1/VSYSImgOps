# DONE 1
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
        $All

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
            $ImageName = Split-Path $item -Leaf

            $ImgWidth = $Image.Width
            $ImgHeight = $Image.Height

            $Image.Dispose()

            if($All){
                [PSCustomObject]@{
                    Width  = $ImgWidth
                    Height = $ImgHeight
                    ImageName = $ImageName
                    ImagePath = $item
                }
            }else{
                [PSCustomObject]@{
                    Width = $ImgWidth
                    Height = $ImgHeight
                    ImageName = $ImageName
                }
            }
            
        }
    }
}

# $ImageA = "D:\Dev\Powershell\VSYSModules\VSYSImgOps\bin\DomColorsTestImages\TestImg 07.jpg"
# $ImageB = "D:\Dev\Powershell\VSYSModules\VSYSImgOps\bin\DomColorsTestImages\TestImg 02.jpg"
# $ImageC = "D:\Dev\Powershell\VSYSModules\VSYSImgOps\bin\DomColorsTestImages\TestImg 05.jpg"
# Get-ImageDimensions $ImageA, $ImageB, $ImageC