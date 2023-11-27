function Confirm-WellFormedHex {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            Position=0,
            ValueFromPipeline
        )]
        $Hex
    )

    process {

        $HexIsWellFormed = $Hex -match '^#([A-Fa-f0-9]{6})$'
        if(!$HexIsWellFormed){
            Write-Error "Your hex input is malformed. Check your format."
            return $false
        }

        # Ensure hex color is 7 characters long
        if ($Hex.Length -ne 7) {
            Write-Host "`$Hex:" $Hex -ForegroundColor Green
            Write-Host "`$Hex.Length:" $Hex.Length -ForegroundColor Green
            Write-Error "Hex color must be 7 characters long including the # symbol."
            return $false
        }

        return $true
    }
}