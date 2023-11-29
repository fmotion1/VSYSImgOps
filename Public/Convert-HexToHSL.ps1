# DONE 1
function Convert-HexToHSL {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.HSLColor])]
    param (
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'Hex'
        )]
        [String[]]$Hex,

        [Parameter(
            Mandatory,
            Position = 0,
            ParameterSetName="HEXStruct",
            ValueFromPipeline
        )]
        [VSYSColorStructs.HexColor[]]$HEXStruct,

        [Parameter(Mandatory = $false)]
        [ValidateSet(0,1,2,3,4)]
        [Int32]
        $Precision = 2
    )

    process {

        $HexToHSL = {

            param ([string]$HexColor)
            $hexval = $HexColor -replace '^#', ''
            $r = [convert]::ToInt32($hexval.SubString(0,2),16) / 255.0
            $g = [convert]::ToInt32($hexval.SubString(2,2),16) / 255.0
            $b = [convert]::ToInt32($hexval.SubString(4,2),16) / 255.0

            # Calculate max and min
            $max = [Math]::Max($r, [Math]::Max($g, $b))
            $min = [Math]::Min($r, [Math]::Min($g, $b))
            $delta = $max - $min

            # Calculate Lightness
            $l = ($max + $min) / 2

            # Calculate Saturation
            $s = $delta -eq 0 ? 0 : $delta / (1 - [Math]::Abs(2 * $l - 1))

            # Calculate Hue
            $h = $delta -eq 0 ? 0 :
                $max -eq $r ? (60 * (($g - $b) / $delta) + 360) % 360 :
                $max -eq $g ? 60 * (($b - $r) / $delta) + 120 :
                60 * (($r - $g) / $delta) + 240


            $Hue = [Math]::Round($h, 2)
            $Saturation = [Math]::Round($s * 100, $Precision)
            $Lightness = [Math]::Round($l * 100, $Precision)

            [VSYSColorStructs.HSLColor]::new($Hue, $Saturation, $Lightness)

        }

        $HexArray = @()
        $InputHex = @()

        if($PSCmdlet.ParameterSetName -eq 'Hex'){
            foreach ($H in $Hex) {
                $InputHex += $H
            }
        }

        if($PSCmdlet.ParameterSetName -eq 'HEXStruct'){
            foreach ($H in $HEXStruct) {
                $InputHex += $H.Hex
            }
        }

        # Validation
        foreach ($H in $InputHex) {
            $ValidHex = Confirm-WellFormedHex -Hex $H
            if($ValidHex){
                $HexArray += $H
            }else{
                $PSCmdlet.ThrowTerminatingError("A hex value supplied is malformed.")
            }
        }

        foreach ($val in $HexArray) {
            & $HexToHSL -HexColor $val
        }

    }
}