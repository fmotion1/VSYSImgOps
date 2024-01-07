# DONE 3
function Convert-HexToHSV {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.HSV])]
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

        $HexToHSV = {

            param ([string]$hex)

            $hex = $hex -replace '^#', ''
            
            # Extract Red, Green, Blue values from Hex
            $r = [convert]::ToInt32($hex.SubString(0, 2), 16) / 255.0
            $g = [convert]::ToInt32($hex.SubString(2, 2), 16) / 255.0
            $b = [convert]::ToInt32($hex.SubString(4, 2), 16) / 255.0

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

            $s = $s * 100
            $v = $v * 100

            [VSYSColorStructs.HSV]::new($h, $s, $v)

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
                Write-Error "A hex value supplied ($H) is malformed."
                return 2
            }
        }

        foreach ($val in $HexArray) {
            & $HexToHSV -hex $val
        }
    }
}

# $S1 = [VSYSColorStructs.HTMLHex]::new('#C71E48')
# $S1 | Convert-HexToHSV

# $Obj1 = [PSCustomObject]@{
#     Hex = '#3DE77F'
# }
# $Obj1 | Convert-HexToHSV