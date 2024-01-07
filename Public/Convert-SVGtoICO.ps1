using namespace VSYSImgOps.SVG
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
                $List.Add($AbsolutePath)
            } else {
                Write-Warning "$AbsolutePath does not exist."
            }
        }
    }

    end {

        $List | ForEach-Object -Parallel {

            $InputSVG = $_
            $RND = Get-RandomAlphanumericString -Length 16
            $SVGFolder = [System.IO.Directory]::GetParent($InputSVG)
            $NewTemp = Join-Path -Path $SVGFolder -ChildPath $RND
            if(-not($NewTemp | Test-Path)){
                New-Item -Path $NewTemp -ItemType Directory -Force
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

                $RSVGParams = "-a", "-w", $outputSize, "-h", $outputSize, "-f", "png", $InputSVG, "-o", "$NewTemp\$size.png"
                & $Using:RSVGConvertCmd $RSVGParams | Out-Null

                $MagickParams = "$NewTemp\$size.png", "-background", "none", "-gravity", "center", "-extent", "${size}x${size}", "png32:$NewTemp\$size.png"
                & $Using:MagickCmd $MagickParams | Out-Null

            }

            $IconTempName = Get-RandomAlphanumericString -Length 15
            & $Using:MagickCmd $($sizes.ForEach{"$NewTemp\$_.png"}) "$NewTemp\$IconTempName.ico" | Out-Null

            $DestFile = [System.IO.Path]::GetFileNameWithoutExtension($InputSVG) + ".ico"
            $DestPath = Join-Path -Path ([System.IO.Path]::GetDirectoryName($InputSVG)) -ChildPath "ICO Conversion"
            if (!(Test-Path -Path $DestPath -PathType Container)) {
                New-Item -Path $DestPath -ItemType Directory -Force | Out-Null
            }

            $TempFilePath = [System.IO.Path]::Combine($NewTemp, "$IconTempName.ico")
            $DestFilePath = [System.IO.Path]::Combine($DestPath, $DestFile)

            $IDX = 2
            $StaticFilename = $DestFilePath.Substring(0, $DestFilePath.LastIndexOf('.'))
            $FileExtension  = [System.IO.Path]::GetExtension($DestFilePath)
            while (Test-Path -LiteralPath $DestFilePath -PathType Leaf) {
                $DestFilePath = "{0}_{1:d1}{2}" -f $StaticFilename, $IDX, $FileExtension
                $IDX++
            }

            if (Test-Path -LiteralPath $TempFilePath -PathType leaf) {
                [IO.File]::Move($TempFilePath, $DestFilePath) | Out-Null
            }

            try {
                Write-Verbose "Removing Temp Directory ($TempDirName)."
                #Remove-Item $NewTemp -Recurse -Force
            }
            catch {
                Write-Error "Can't remove temp dir. ($NewTemp)"
            }

        } -ThrottleLimit $MaxThreads

        # foreach ($Dir in $TempDirList) {
        #     Write-Host "Removing temp directory: $Dir" -ForegroundColor White
        #     Remove-Item -LiteralPath $Dir -Recurse
        # }
    }
}