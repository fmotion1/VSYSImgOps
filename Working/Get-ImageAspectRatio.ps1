﻿# DONE 1
function Get-ImageAspectRatio {
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
        $IncludePath
    )

    begin {
        $GetGreatestCommonDivisor = {
            param (
                [int]$a,
                [int]$b
            )
            while ($b -ne 0) {
                $temp = $b
                $b = $a % $b
                $a = $temp
            }
            return $a
        }
    }

    process {
        # Resolve path(s)
        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            $resolvedPaths = Resolve-Path -Path $Path | Select-Object -ExpandProperty Path
        } elseif ($PSCmdlet.ParameterSetName -eq 'LiteralPath') {
            $resolvedPaths = Resolve-Path -LiteralPath $LiteralPath | Select-Object -ExpandProperty Path
        }

        try {

            foreach ($item in $resolvedPaths) {

                $image = [System.Drawing.Bitmap]::FromFile($item)
                $width = $image.Width
                $height = $image.Height
                $image.Dispose()
        
                $gcd = & $GetGreatestCommonDivisor $width $height
        
                $aspectRatioW = ($width / $gcd) -as [String]
                $aspectRatioH = ($height / $gcd) -as [String]
                $aspectRatio = $aspectRatioW + ":" + $aspectRatioH
                
                if($IncludePath){
                    [PSCustomObject][ordered]@{
                        AspectRatio = $aspectRatio
                        Image = Split-Path $item -Leaf
                        Path = Split-Path $item -Parent
                    }
                } else {
                    [PSCustomObject][ordered]@{
                        AspectRatio = $aspectRatio
                    }
                }
            }
        }
        catch {
            throw "An error occured: $_"
        }
    }
}


# $ImageA = "D:\Dev\Powershell\VSYSModules\VSYSImgOps\bin\DomColorsTestImages\TestImg 07.jpg"
# $ImageB = "D:\Dev\Powershell\VSYSModules\VSYSImgOps\bin\DomColorsTestImages\TestImg 02.jpg"
# $ImageC = "D:\Dev\Powershell\VSYSModules\VSYSImgOps\bin\DomColorsTestImages\TestImg 05.jpg"
# Get-ImageAspectRatio -Path $ImageA, $ImageB, $ImageC 