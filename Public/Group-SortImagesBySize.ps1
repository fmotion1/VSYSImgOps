function Group-SortImagesBySize {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        $Files,
        [Int32] $MaxThreads = 16
    )

    begin {
        $List = [System.Collections.Generic.HashSet[string]]::new()
    }

    process {

        Measure-Command {

            foreach ($P in $Files) {
                $Path = if ($P -is [String])  { $P }
                        elseif ($P.Path)	  { $P.Path }
                        elseif ($P.FullName)  { $P.FullName }
                        elseif ($P.PSPath)	  { $P.PSPath }
                        else { Write-Error "$P is an unsupported type."; throw }

                $AbsolutePath = if ([System.IO.Path]::IsPathRooted($Path)) { $Path }
                else { Resolve-Path -Path $Path }

                if (Test-Path -Path $AbsolutePath) {
                    $rePattern = "\.(png|jpg|jpeg|gif|bmp|webp|tif|tiff|svg)$"
                    if ($AbsolutePath -match $rePattern) {
                        $List.Add($AbsolutePath)
                    }
                } else {
                    Write-Warning "$AbsolutePath does not exist."
                }
            }
        }
    }

    end {

        $List | ForEach-Object -Parallel {

            $Image = $_
            $TargetFolder = "No Size"

            if ([System.IO.Path]::GetExtension($Image) -eq '.svg') {

                $SvgDimensions = Get-SvgDimensions -SVGFiles $Image

                if(($SvgDimensions.ViewboxWidth -ne 0) -and ($SvgDimensions.ViewboxHeight -ne 0)){
                    $SVGW = $SvgDimensions.ViewboxWidth
                    $SVGH = $SvgDimensions.ViewboxHeight
                }elseif(($SvgDimensions.Width -ne 0) -and ($SvgDimensions.Height -ne 0)){
                    $SVGW = $SvgDimensions.Width
                    $SVGH = $SvgDimensions.Height
                }
                if(($SVGW -ne 0) -and ($SVGH -ne 0)){
                    $SVGW = [math]::Round($SVGW,2)
                    $SVGH = [math]::Round($SVGH,2)
                    $TargetFolder = "$SVGW" + "x" + "$SVGH"
                }

            } else {

                $ImageRef = [System.Drawing.Image]::FromFile($Image)
                [int]$ImgWidth  = $ImageRef.Width
                [int]$ImgHeight = $ImageRef.Height
                $ImageRef.Dispose()

                if(($ImgWidth -ne 0) -or ($ImgHeight -ne 0)) {
                    $TargetFolder = "$ImgWidth" + "x" + "$ImgHeight"
                }

            }

            $ImgDirectory = [IO.Path]::GetDirectoryName($Image)
            $ImgFilename  = [IO.Path]::GetFileName($Image)
            $OutputFolder = Join-Path -Path $ImgDirectory -ChildPath $TargetFolder
            
            if (!(Test-Path -LiteralPath $OutputFolder -PathType Container)) {
                [IO.Directory]::CreateDirectory($OutputFolder) | Out-Null
            }

            $DestFile = Join-Path -Path $OutputFolder -ChildPath $ImgFilename
            [IO.File]::Move($Image, $DestFile)
            
        } -ThrottleLimit $MaxThreads
    }
}