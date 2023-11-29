# DONE 1
function Confirm-WellFormedHex {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            Position=0,
            ValueFromPipeline
        )]
        $Hex,

        [Parameter(Mandatory=$false)]
        [Switch]
        $IncludeAlpha
    )

    process {

        $RegExNoAlpha = '^#([A-Fa-f0-9]{6})$'
        $RegExWithAlpha = '^#([0-9A-Fa-f]{6})([0-9A-Fa-f]{2})$'

        if(!$IncludeAlpha){
            $WellFormed = $Hex -match $RegExNoAlpha
            if(!$WellFormed){
                Write-Error "Your hex input is malformed. Check your format."
                return $false
            }
        }else{
            $WellFormed = $Hex -match $RegExWithAlpha
            if(!$WellFormed){
                Write-Error "Your hex input is malformed. Check your format."
                return $false
            }
        }

        return $true
    }
}
