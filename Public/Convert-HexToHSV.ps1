# DONE 1
function Convert-HexToHSV {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.HSVColor])]
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

        $HexToHSV = {

            param ([string]$HexColor)
            $hexval = $HexColor -replace '^#', ''
            $r = [convert]::ToInt32($hexval.SubString(0, 2), 16) / 255.0
            $g = [convert]::ToInt32($hexval.SubString(2, 2), 16) / 255.0
            $b = [convert]::ToInt32($hexval.SubString(4, 2), 16) / 255.0

            $max = [Math]::Max($r, [Math]::Max($g, $b))
            $min = [Math]::Min($r, [Math]::Min($g, $b))
            $delta = $max - $min

            # Calculate Hue
            $h = $delta -eq 0 ? 0 :
                $max -eq $r ? (60 * (($g - $b) / $delta) + 360) % 360 :
                $max -eq $g ? 60 * (($b - $r) / $delta) + 120 :
                60 * (($r - $g) / $delta) + 240

            # Calculate Saturation
            $s = $max -eq 0 ? 0 : $delta / $max

            # Value is the same as Max
            $v = $max
            
            $Hue = [Math]::Round($h, $Precision)
            $Saturation = [Math]::Round($s * 100, $Precision)
            $Value = [Math]::Round($v * 100, $Precision)

            [VSYSColorStructs.HSVColor]::new($Hue, $Saturation, $Value)
            
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
            & $HexToHSV -HexColor $val
        }
    }
}

Convert-HexToHSV -Hex '#FFFFFF', '#445867'