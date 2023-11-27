function Convert-HexToRGB {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.RGBColor])]
    param (
        [Parameter(
            Mandatory,
            ParameterSetName = 'Hex',
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]$Hex
    )

    begin {
        $ValidHex = @()
    }

    process {
   
        foreach ($C in $Hex) {

            $isWellFormed = $C -match '^#([A-Fa-f0-9]{6})$'
            if(!$isWellFormed){
                Write-Error "Your hex input is malformed. Check your input value."
                exit 2
            }

            # Remove hash if present
            if ($C.StartsWith("#")) {
                $C = $C.Substring(1)
            }
        
            # Ensure hex color is 6 characters long
            if ($C.Length -ne 6) {
                Write-Error "Hex color must be 6 characters long excluding the # symbol."
                exit 2
            }

            $ValidHex += $C
            
        }

        foreach ($HexColor in $ValidHex) {

            #Write-Host "`$HexColor:" $HexColor -ForegroundColor Green

            # Extract the red, green, and blue components
            $r = [convert]::ToInt32($HexColor.Substring(0, 2), 16)
            $g = [convert]::ToInt32($HexColor.Substring(2, 2), 16)
            $b = [convert]::ToInt32($HexColor.Substring(4, 2), 16)

            $RGBStruct = [VSYSColorStructs.RGBColor]::new()
            $RGBStruct.Red = $r
            $RGBStruct.Green = $g
            $RGBStruct.Blue = $b

            return $RGBStruct
        }
    }
}

# '#FFFFFF', '#445867' | Convert-HexToRGB