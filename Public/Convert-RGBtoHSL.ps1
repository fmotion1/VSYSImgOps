# FUNCTION IS DONE
function Convert-RGBToHSL {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.HSLColor])]
    param (
        [Parameter(
            Mandatory,
            Position=0,
            ParameterSetName="PSCustom",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [pscustomobject[]]$Object,

        [Parameter(Mandatory, ParameterSetName = 'String')]
        [ValidateNotNullOrEmpty()]
        [string]$R,

        [Parameter(Mandatory, ParameterSetName = 'String')]
        [ValidateNotNullOrEmpty()]
        [string]$G,

        [Parameter(Mandatory, ParameterSetName = 'String')]
        [ValidateNotNullOrEmpty()]
        [string]$B
    )

    process {

        $RGBToHSL = {
            param (
                [String]$R,
                [String]$G,
                [String]$B
            )

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

            return @($hRounded, $sRounded, $lRounded)

        }

        if($PSCmdlet.ParameterSetName -eq 'PSCustom'){
            foreach ($RGBObject in $Object) {
                $RGBObject.R = $Object.R
                $RGBObject.G = $Object.G
                $RGBObject.B = $Object.B
                $ObjectsCollection = & $RGBToHSL -R $RGBObject.R -G $RGBObject.G -B $RGBObject.B
            }
        }

        if($PSCmdlet.ParameterSetName -eq 'String'){
            $ObjectsCollection = & $RGBToHSL -R $R -G $G -B $B
        }

        $HSLStruct = [VSYSColorStructs.HSLColor]::new()
        $HSLStruct.Hue = $ObjectsCollection[0]
        $HSLStruct.Saturation = $ObjectsCollection[1]
        $HSLStruct.Lightness = $ObjectsCollection[2]
        $HSLStruct
    }
}

#Convert-RGBToHSL -R 200 -G 200 -B 200
