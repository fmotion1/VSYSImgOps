# FUNCTION IS DONE
function Convert-HexToRGB {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.RGBColor])]
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
            $R = [convert]::ToInt32($HexValTest.Substring(0, 2), 16)
            $G = [convert]::ToInt32($HexValTest.Substring(2, 2), 16)
            $B = [convert]::ToInt32($HexValTest.Substring(4, 2), 16)
            
            $RGBStruct = [VSYSColorStructs.RGBColor]::new()
            $RGBStruct.Red = $R
            $RGBStruct.Green = $G
            $RGBStruct.Blue = $B
            $RGBStruct

        }
    }
}

# Convert-HexToRGB -Hex '#FFFFFF', '#445867'