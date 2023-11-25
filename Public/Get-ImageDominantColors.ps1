function Get-ImageDominantColors {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position=0)]
        [Alias("i")]
        $Image,

        [Parameter(Mandatory=$false)]
        [Alias("c")]
        [Int32]
        $NumColors
    )

    begin {
        if(($NumColors -lt 2) -or ($NumColors -gt 15)){
            Write-Error "Invalid number of colors. Range is 2-15."
            return
        }
    }

    process {

        & "$PSScriptRoot/../bin/DomColorsVENV/Scripts/Activate.ps1"
        $Script = "$PSScriptRoot/../bin/DomColorsScripts/domcolorsA.py"
        $Params = $Script, '-i', $Image, '-n', $NumColors, '-o', 'List'

        $Colors = & python $Params
        $Colors = $Colors.Split([Environment]::NewLine, [StringSplitOptions]::RemoveEmptyEntries)
        
    }

    end {
        & deactivate
    }

}