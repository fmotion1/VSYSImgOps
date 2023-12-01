# DONE 1
function Convert-RGBToHSV {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.HSVColor])]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'Individual'
        )]
        [Alias("R")]
        [byte]$Red,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'Individual'
        )]
        [Alias("G")]
        [byte]$Green,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'Individual'
        )]
        [Alias("B")]
        [byte]$Blue,

        [Parameter(
            Mandatory,
            Position = 0,
            ParameterSetName="RGBStruct",
            ValueFromPipeline
        )]
        [VSYSColorStructs.RGBColor[]]$RGBStruct
    )

    process {

        $RGBToHSV = {
            param ([byte]$R, [byte]$G, [byte]$B)

            # Normalize RGB values to the range 0-1
            $red   = $R / 255.0
            $green = $G / 255.0
            $blue  = $B / 255.0

            # Calculate min and max RGB values
            $max = [Math]::Max($red, [Math]::Max($green, $blue))
            $min = [Math]::Min($red, [Math]::Min($green, $blue))
            $delta = $max - $min

            # Value
            $v = $max

            # Saturation
            $s = 0
            if ($max -ne 0) {
                $s = $delta / $max
            }

            # Hue
            $h = 0
            if ($delta -ne 0) {
                if ($max -eq $red) {
                    $h = 60 * (($green - $blue) / $delta % 6)
                } elseif ($max -eq $green) {
                    $h = 60 * (($blue - $red) / $delta + 2)
                } elseif ($max -eq $blue) {
                    $h = 60 * (($red - $green) / $delta + 4)
                }

                # Ensure Hue is positive
                if ($h -lt 0) {
                    $h += 360
                }
            }

            # Convert to percentages for Saturation and Value
            $s *= 100
            $v *= 100

            $hRounded = [Math]::Round($h, 2)
            $sRounded = [Math]::Round($s, 2)
            $vRounded = [Math]::Round($v, 2)

            [VSYSColorStructs.HSVColor]::new($hRounded, $sRounded, $vRounded)
        }

        if($PSCmdlet.ParameterSetName -eq 'Individual'){
            & $RGBToHSV -R $Red -G $Green -B $Blue
        }

        if($PSCmdlet.ParameterSetName -eq 'RGBStruct'){
            foreach($Color in $RGBStruct){
                $Obj = [PSCustomObject]@{
                    R = $Color.R
                    G = $Color.G
                    B = $Color.B
                }
                & $RGBToHSV -R $Obj.R -G $Obj.G -B $Obj.B
            }
        }
    }
}

# Convert-RGBToHSV -R 255 -G 0 -B 255