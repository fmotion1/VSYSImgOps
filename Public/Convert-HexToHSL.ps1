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
        [pscustomobject[]]$HexObjects,

        [Parameter(
            Mandatory,
            ParameterSetName = 'String',
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]$HexStrings

    )

    process {

        $HexArray = @()
        $ActualHex = @()

        if($PSCmdlet.ParameterSetName -eq 'PSCustom'){
            foreach ($HexObject in $HexObjects) {
                $ActualHex += $HexObject.Hex
            }
        }
        if($PSCmdlet.ParameterSetName -eq 'String'){
            foreach ($HexString in $HexStrings) {
                $ActualHex += $HexString
            }
        }

        # Validation
        foreach ($Hex in $ActualHex) {
            $ValidHex = Confirm-WellFormedHex -Hex $Hex
            if($ValidHex){
                $HexArray += $Hex
            }
        }

        foreach ($Hex in $HexArray) {

            $RGBVals = Convert-HexToRGB "$Hex"
            $r = $RGBVals.Red
            $g = $RGBVals.Green
            $b = $RGBVals.Blue

            $HSLObject = Convert-RGBToHSL -Red $r -Green $g -Blue $b

            $OutHue = $HSLObject.Hue
            $OutSat = $HSLObject.Saturation
            $OutLight = $HSLObject.Lightness

            $HSLStruct = [VSYSColorStructs.HSLColor]::new()
            $HSLStruct.Hue = $OutHue
            $HSLStruct.Saturation = $OutSat
            $HSLStruct.Lightness = $OutLight
            $HSLStruct

        }
    }
}