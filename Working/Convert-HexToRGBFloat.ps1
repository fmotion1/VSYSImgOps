# DONE 2
function Convert-HexToRGBFloat {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.RGBFloat])]
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
            ParameterSetName="HTMLHex",
            ValueFromPipeline
        )]
        [VSYSColorStructs.HTMLHex[]]$HTMLHex,

        [Parameter(Mandatory = $false)]
        [ValidateSet(1,2,3,4,5,6,7,8,9,"MAX",IgnoreCase=$true)]
        $Precision = "MAX"

    )

    process {

        $HexToRGBFloat = {

            param ($hex)

            $hex = $hex -replace '^#', ''

            $R = [System.Convert]::ToInt32($hex.Substring(0,2),16) / 255
            $G = [System.Convert]::ToInt32($hex.Substring(2,2),16) / 255
            $B = [System.Convert]::ToInt32($hex.Substring(4,2),16) / 255

            if($Precision -ne "MAX"){
                $R = [System.Math]::Round($R, $Precision, [System.MidpointRounding]::ToEven)
                $G = [System.Math]::Round($G, $Precision, [System.MidpointRounding]::ToEven)
                $B = [System.Math]::Round($B, $Precision, [System.MidpointRounding]::ToEven)
            }

            [VSYSColorStructs.RGBFloat]::new($R, $G, $B)
        }

        $InputHex = @()
        if($PSCmdlet.ParameterSetName -eq 'String') {
            $Hex | % { $InputHex += $_}
        }
        if($PSCmdlet.ParameterSetName -eq 'HTMLHex'){
            $HTMLHex | % { $InputHex += $_}
        }

        # Validation
        foreach ($H in $InputHex) {
            if(Confirm-WellFormedHex $H){
                & $HexToRGBFloat -hex $H
            } else {
                Write-Error "A hex value supplied ($H) is malformed."
                return 2
            }
        }
    }
}

# [VSYSColorStructs.HTMLHex]::new("#AF0FCC") | Convert-HexToRGBFloat
# $Obj = "#AAFF44", '#294BAE', '#FE9921' | Convert-HexToRGBFloat
# $Obj