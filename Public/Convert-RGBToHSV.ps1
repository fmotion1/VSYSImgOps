# FUNCTION IS DONE
function Convert-RGBToHSV {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.HSVColor])]
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

        $RGBToHSV = {
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

            return @($hRounded, $sRounded, $vRounded)
        }

        if($PSCmdlet.ParameterSetName -eq 'PSCustom'){
            foreach ($RGBObject in $Object) {
                $RGBObject.R = $Object.R
                $RGBObject.G = $Object.G
                $RGBObject.B = $Object.B
                $ObjectsCollection = & $RGBToHSV -R $RGBObject.R -G $RGBObject.G -B $RGBObject.B
            }
        }

        if($PSCmdlet.ParameterSetName -eq 'String'){
            $ObjectsCollection = & $RGBToHSV -R $R -G $G -B $B
        }

        $HSVStruct = [VSYSColorStructs.HSVColor]::new()
        $HSVStruct.Hue = $ObjectsCollection[0]
        $HSVStruct.Saturation = $ObjectsCollection[1]
        $HSVStruct.Value = $ObjectsCollection[2]
        $HSVStruct

    }
}