function Convert-SVGtoICO {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        $Files,
        [Switch] $HonorSub16pxSizes,
        [Int32] $MaxThreads = 16
    )

    begin {

        try {
            $RSVGConvertCmd = Get-Command rsvg-convert.exe
        } catch {
            Write-Error "rsvg-convert.exe cannot be found in PATH."
            throw $_
        }

        try {
            $MagickCmd = get-command magick.exe
        } catch {
            Write-Error "magick.exe (ImageMagick) cannot be found in PATH."
            throw $_
        }

        $List = [System.Collections.Generic.List[string]]@()
    }

    process {

        foreach ($P in $Files) {

            $Path = if ($P -is [String])  { $P }
                    elseif ($P.Path)	  { $P.Path }
                    elseif ($P.FullName)  { $P.FullName }
                    elseif ($P.PSPath)	  { $P.PSPath }
                    else { Write-Error "$P is an unsupported type."; throw }

            $AbsolutePath = if ([System.IO.Path]::IsPathRooted($Path)) { $Path }
            else { Resolve-Path -Path $Path }

            if (Test-Path -Path $AbsolutePath) {
                if([System.IO.Path]::GetExtension($AbsolutePath) -eq '.svg'){
                    $List.Add($AbsolutePath)
                }
            } else {
                Write-Warning "$AbsolutePath does not exist."
            }
        }
    }

    end {

        $Output = [System.Collections.Concurrent.ConcurrentDictionary[string,object]]::new()

        $List | ForEach-Object -Parallel {

            $InputSVG = $_
            $InputSVGFilename = Split-Path -Path $InputSVG -Leaf
            $SVGFolder = [System.IO.Directory]::GetParent($InputSVG)
            $NewTemp = Join-Path -Path $SVGFolder -ChildPath "ICO Conversion"
            if(-not($NewTemp | Test-Path)){
                New-Item -Path $NewTemp -ItemType Directory -Force | Out-Null
            }

            $SvgDimensions = Get-SvgDimensions -SVGFiles $InputSVG

            if(($SvgDimensions.ViewboxWidth -ne 0) -and ($SvgDimensions.ViewboxHeight -ne 0)){
                $SVGW = $SvgDimensions.ViewboxWidth
                $SVGH = $SvgDimensions.ViewboxHeight
            }elseif(($SvgDimensions.Width -ne 0) -and ($SvgDimensions.Height -ne 0)){
                $SVGW = $SvgDimensions.Width
                $SVGH = $SvgDimensions.Height
            }

            $sizes = 16, 20, 24, 32, 48, 256
            foreach ($size in $sizes) {
                $outputSize = if ($size -eq 16 -and $SVGW -lt 16 -and $SVGH -lt 16 -and $Using:HonorSub16pxSizes) {
                    [math]::Max($SVGW, $SVGH)
                } else {
                    $size
                }

                $RSVGParams = "-a", "-w", $outputSize, "-h", $outputSize, "-f", "png", $InputSVG, "-o", "$NewTemp\$InputSVGFilename-$size.png"
                & $Using:RSVGConvertCmd $RSVGParams | Out-Null

                $MagickParams = "$NewTemp\$InputSVGFilename-$size.png", "-background", "none", "-gravity", "center", "-extent", "${size}x${size}", "png32:$NewTemp\$InputSVGFilename-$size.png"
                & $Using:MagickCmd $MagickParams | Out-Null

            }

            & $Using:MagickCmd $($sizes.ForEach{"$NewTemp\$InputSVGFilename-$_.png"}) "$NewTemp\$InputSVGFilename.ico" | Out-Null

            $dict = $using:Output
            $dict.TryAdd("tempdir", $NewTemp) | Out-Null

        } -ThrottleLimit $MaxThreads

        $OutputDir = $Output["tempdir"]
        if($OutputDir | Test-Path){
            Get-ChildItem -LiteralPath $OutputDir -Filter *.png -Recurse | Remove-Item -Force | Out-Null
        }
    }
}