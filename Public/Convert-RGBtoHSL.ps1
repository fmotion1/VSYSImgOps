# DONE 1
function Convert-RGBToHSL {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.HSLColor])]
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

        $RGBToHSL = {
            param ([byte]$R, [byte]$G, [byte]$B)

            # Normalize RGB values to the range 0-1
            $red   = $R / 255.0
            $green = $G / 255.0
            $blue  = $B / 255.0

            # Calculate min and max RGB values
            $max = [Math]::Max($red, [Math]::Max($green, $blue))
            $min = [Math]::Min($red, [Math]::Min($green, $blue))
            $delta = $max - $min

            # Luminance
            $l = ($max + $min) / 2

            # Saturation
            if ($delta -eq 0) {
                $s = 0
            } else {
                $s = $delta / (1 - [Math]::Abs(2 * $l - 1))
            }

            # Hue
            $h = 0
            if ($delta -ne 0) {
                switch ($max) {
                    $red   { $h = 60 * (($green - $blue) / $delta % 6) }
                    $green { $h = 60 * (($blue - $red) / $delta + 2) }
                    $blue  { $h = 60 * (($red - $green) / $delta + 4) }
                }

                # Ensure Hue is positive
                if ($h -lt 0) {
                    $h += 360
                }
            }

            # Convert to percentages
            $s *= 100
            $l *= 100

            $hRounded = [Math]::Round($h, 2)
            $sRounded = [Math]::Round($s, 2)
            $lRounded = [Math]::Round($l, 2)

            [VSYSColorStructs.HSLColor]::new($hRounded, $sRounded, $lRounded)

        }

        if($PSCmdlet.ParameterSetName -eq 'Individual'){
            & $RGBToHSL -R $Red -G $Green -B $Blue
        }

        if($PSCmdlet.ParameterSetName -eq 'RGBStruct'){
            foreach($Color in $RGBStruct){
                $Obj = [PSCustomObject]@{
                    R = $Color.R
                    G = $Color.G
                    B = $Color.B
                }
                & $RGBToHSL -R $Obj.R -G $Obj.G -B $Obj.B
            }
        }
    }
}
