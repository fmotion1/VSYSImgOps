# DONE 3
function Convert-HexToRGBByte {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.RGBByte])]
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

        $HexToRGBByte = {

            param ([string]$HexColor)

            $hexval = $HexColor -replace '^#', ''
            $r = [convert]::ToInt32($hexval.Substring(0, 2), 16)
            $g = [convert]::ToInt32($hexval.Substring(2, 2), 16)
            $b = [convert]::ToInt32($hexval.Substring(4, 2), 16)

            [VSYSColorStructs.RGBByte]::new($r, $g, $b)
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
            & $HexToRGBByte -HexColor $val
        }
    }
}

# $Val = Convert-HexToRGBByte -Hex '#55C881'
# $Val 
# $S = [VSYSColorStructs.HTMLHex]::new('#294BAE')
# $S | Convert-HexToRGBByte
