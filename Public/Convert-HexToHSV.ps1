# FUNCTION IS DONE
function Convert-HexToHSV {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.HSVColor])]
    param (
        [Parameter(
            Mandatory,
            ParameterSetName = 'PSCustom',
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [pscustomobject[]]$Object,

        [Parameter(
            Mandatory,
            ParameterSetName = 'String',
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]$Hex

    )

    process {

        $InputHex = @()
        $ValidHexArray = @()

        if($PSCmdlet.ParameterSetName -eq 'PSCustom'){
            foreach ($HexObject in $Object) {
                $InputHex += $HexObject.Hex
            }
        }
        if($PSCmdlet.ParameterSetName -eq 'String'){
            foreach ($HexString in $Hex) {
                $InputHex += $HexString
            }
        }

        # Validation
        foreach ($HexTest in $InputHex) {
            $IsValidHex = Confirm-WellFormedHex -Hex $HexTest
            if($IsValidHex){
                $ValidHexArray += $HexTest
            }
        }

        foreach ($HexValue in $ValidHexArray) {

            $HexValTest = $HexValue.TrimStart('#')

            # Convert Hex to RGB
            $R = [convert]::ToInt32($HexValTest.Substring(0,2), 16)
            $G = [convert]::ToInt32($HexValTest.Substring(2,2), 16)
            $B = [convert]::ToInt32($HexValTest.Substring(4,2), 16)

            # Convert RGB to HSV
            $HSV = Convert-RGBToHSV -R $R -G $G -B $B

            $HVal = [Math]::Round($HSV.Hue)
            $SVal = [Math]::Round($HSV.Saturation)
            $VVal = [Math]::Round($HSV.Value)

            $HSVStruct = [VSYSColorStructs.HSVColor]::new()
            $HSVStruct.Hue = $HVal
            $HSVStruct.Saturation = $SVal
            $HSVStruct.Value = $VVal
            $HSVStruct
        }
    }
}

# Convert-HexToHSV -Hex '#FFFFFF', '#445867'