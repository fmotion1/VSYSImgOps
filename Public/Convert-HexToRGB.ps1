# DONE 1
function Convert-HexToRGB {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.RGBColor])]
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

        $HexToRGB = {
            param ([string]$HexColor)
            $hexval = $HexColor -replace '^#', ''
            $r = [convert]::ToInt32($hexval.Substring(0, 2), 16)
            $g = [convert]::ToInt32($hexval.Substring(2, 2), 16)
            $b = [convert]::ToInt32($hexval.Substring(4, 2), 16)
            [VSYSColorStructs.RGBColor]::new($r, $g, $b)
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
            & $HexToRGB -HexColor $val
        }
    }
}

# $Val = Convert-HexToRGB -Hex '#FFFFFF'
# $Val.ToString()