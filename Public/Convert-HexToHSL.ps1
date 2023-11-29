# FUNCTION IS DONE
function Convert-HexToHSL {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.HSLColor])]
    param (
        [Parameter(
            Mandatory,
            ParameterSetName = 'PSCustom',
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject[]]$Object,

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

        $HexArray = @()
        $InputHex = @()

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
            $ValidHex = Confirm-WellFormedHex -Hex $HexTest
            if($ValidHex){
                $HexArray += $HexTest
            }
        }

        foreach ($HexVal in $HexArray) {

            $RGBVals = Convert-HexToRGB -Hex $HexVal

            $R = $RGBVals.Red
            $G = $RGBVals.Green
            $B = $RGBVals.Blue

            $HSLObject = Convert-RGBToHSL -R $R -G $G -B $B

            $OutHue = $HSLObject.Hue
            $OutSat = $HSLObject.Saturation
            $OutLight = $HSLObject.Lightness

            $HSLStruct = [VSYSColorStructs.HSLColor]::new()
            $HSLStruct.Hex = $HexVal
            $HSLStruct.Hue = $OutHue
            $HSLStruct.Saturation = $OutSat
            $HSLStruct.Lightness = $OutLight
            $HSLStruct

        }
    }
}

#Convert-HexToHSL -Hex "#55FF33", "#FFFFFF"