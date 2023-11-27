function Convert-RGBToHSL {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.HSLColor])]
    param (

        [Parameter(
            Mandatory,
            Position=0,
            ValueFromPipeline,
            ParameterSetName="ObjectInput")]
        [pscustomobject[]]$RGBObjects,

        [Parameter(Mandatory,ParameterSetName='SeparateInput')]
        [int]$Red,   # Red value (0-255)

        [Parameter(Mandatory,ParameterSetName='SeparateInput')]
        [int]$Green, # Green value (0-255)

        [Parameter(Mandatory,ParameterSetName='SeparateInput')]
        [int]$Blue   # Blue value (0-255)
    )

    process {

        if($PSCmdlet.ParameterSetName -eq 'ObjectInput'){

            foreach ($Obj in $RGBObjects) {

                $Red   = $Obj.R
                $Green = $Obj.G
                $Blue  = $Obj.B

            }
        }

        if($PSCmdlet.ParameterSetName -eq 'SeparateInput'){
            $ROB = (($Red -lt 0) -or ($Red -gt 255))
            $GOB = (($Green -lt 0) -or ($Green -gt 255))
            $BOB = (($Blue -lt 0) -or ($Blue -gt 255))

            if($ROB -or $GOB -or $BOB){
                Write-Error "One of your input color values is out of bounds. Color values must be between 0 and 255"
                exit 2
            }
        }

        # Normalize RGB values to the range 0-1
        $r = $Red / 255.0
        $g = $Green / 255.0
        $b = $Blue / 255.0

        # Calculate min and max RGB values
        $max = [Math]::Max($r, [Math]::Max($g, $b))
        $min = [Math]::Min($r, [Math]::Min($g, $b))
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
                $r { $h = 60 * (($g - $b) / $delta % 6) }
                $g { $h = 60 * (($b - $r) / $delta + 2) }
                $b { $h = 60 * (($r - $g) / $delta + 4) }
            }

            # Ensure Hue is positive
            if ($h -lt 0) {
                $h += 360
            }
        }

        # Convert to percentages
        $s *= 100
        $l *= 100


        $HSLStruct = [VSYSColorStructs.HSLColor]::new()
        $HOutput = [Math]::Round($h, 2)
        $SOutput = [Math]::Round($s, 2)
        $LOutput = [Math]::Round($l, 2)

        $HSLStruct.Hue = $HOutput
        $HSLStruct.Saturation = $SOutput
        $HSLStruct.Lightness = $LOutput
        return $HSLStruct

    }
}


# $Obj1 = [PSCustomObject]@{
#     R = 110
#     G = 233
#     B = 50
# }

# $Obj2 = [PSCustomObject]@{
#     R = 50
#     G = 25
#     B = 70
# }

# $Results = $Obj1, $Obj2 | Convert-RGBToHSL
