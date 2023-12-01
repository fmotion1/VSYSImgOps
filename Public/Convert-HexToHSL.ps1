# DONE 3
function Convert-HexToHSL {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.HSL])]
    param (
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'String'
        )]
        [String[]]$Hex,

        [Parameter(
            Mandatory,
            Position = 0,
            ParameterSetName="Struct",
            ValueFromPipeline
        )]
        [VSYSColorStructs.HTMLHex[]]$Struct
    )

    process {

        $HexToHSL = {

            param ([string]$hex)

            $hex = $hex -replace '^#', ''

            # Extract Red, Green, Blue values from Hex
            $r = [convert]::ToInt32($hex.SubString(0, 2), 16) / 255.0
            $g = [convert]::ToInt32($hex.SubString(2, 2), 16) / 255.0
            $b = [convert]::ToInt32($hex.SubString(4, 2), 16) / 255.0

            # Find max and min values among RGB
            $max = [Math]::Max([Math]::Max($r, $g), $b)
            $min = [Math]::Min([Math]::Min($r, $g), $b)
            $delta = $max - $min

            # Lightness calculation
            $l = ($max + $min) / 2

            # Saturation calculation
            if ($delta -eq 0) {
                $s = 0
                $h = 0
            } else {
                $s = $delta / (1 - [Math]::Abs(2 * $l - 1))

                # Hue calculation
                if ($max -eq $r) {
                    $h = 60 * (($g - $b) / $delta)
                    if ($g -lt $b) { $h += 360 }
                } elseif ($max -eq $g) {
                    $h = 60 * (($b - $r) / $delta + 2)
                } else {
                    $h = 60 * (($r - $g) / $delta + 4)
                }
            }

            $hue = $h
            $sat = $s * 100
            $light = $l * 100
        
            [VSYSColorStructs.HSL]::new($hue, $sat, $light)

        }

        $HexArray = @()
        $InputHex = @()

        if($PSCmdlet.ParameterSetName -eq 'String'){
            foreach ($H in $Hex) {
                $InputHex += $H
            }
        }

        if($PSCmdlet.ParameterSetName -eq 'Struct'){
            foreach ($H in $Struct) {
                $InputHex += $H.Hex
            }
        }

        # Validation
        foreach ($H in $InputHex) {
            $ValidHex = Confirm-WellFormedHex -Hex $H
            if($ValidHex){
                $HexArray += $H
            }else{
                Write-Error ("A hex value supplied ($H) is malformed.")
                return 2
            }
        }

        foreach ($val in $HexArray) {
            & $HexToHSL -hex $val
        }
    }
}


# $St1 = [VSYSColorStructs.HTMLHex]::new("#FFFFFF")
# $St2 = [VSYSColorStructs.HTMLHex]::new("#C71E48")
# $St3 = [VSYSColorStructs.HTMLHex]::new("#2AB127")
# $St1, $St2, $St3 | Convert-HexToHSL | Format-List


