# DONE 1
function Get-ImageDominantColors {
    [CmdletBinding()]
    param (
        [parameter(
            Mandatory,
            ParameterSetName = 'Path',
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string]$Path,

        [parameter(
            Mandatory,
            ParameterSetName = 'LiteralPath',
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [Alias('PSPath')]
        [string]$LiteralPath,

        [Parameter(Mandatory = $false)]
        [Int32]
        $PreResize = 200,

        [Parameter(Mandatory=$false)]
        [Alias("c")]
        [Int32]
        $NumColors = 8,

        [Parameter(Mandatory=$false)]
        [Switch]
        $PreviewColors,

        [Parameter(Mandatory = $false)]
        [Int32]
        $PreviewWidth = 120
    )

    begin {

        if(($NumColors -lt 2) -or ($NumColors -gt 15)){
            Write-Error "Invalid number of colors. Range is 2-15."
            return 2
        }
    }

    process {

        & "$PSScriptRoot\..\bin\DomColorsVENV\Scripts\Activate.ps1"
        $Script = "$PSScriptRoot\..\bin\DomColorsScripts\domcolorsMain.py"
        $PYCMD  = "$PSScriptRoot\..\bin\DomColorsVENV\Scripts\python.exe"
        $Params = $Script, '-i', $Path, '-r', $PreResize, '-n', $NumColors, '-o', 'List'
        $Colors = & $PYCMD $Params

        $PSObjArr = @()

        for ($idx = 0; $idx -lt $Colors.Count; $idx++) {
            $PSO = [PSCustomObject]@{
                Index = $idx
                Hex = $Colors[$idx]
                RGB = Convert-HexToRGB -Hex $Colors[$idx]
                HSL = Convert-HexToHSL -Hex $Colors[$idx]
            }
            $PSObjArr += $PSO
        }

        
    }

    end {

        & deactivate

        if($PreviewColors){
            $ColorObjects = @()
            foreach ($Obj in $PSObjArr) {
                $ColorObjects += @{ Label = $Obj.Hex; Value = 1.5; Color = $Obj.Hex }
            }
            Format-SpectreBreakdownChart -Data $ColorObjects -Width $PreviewWidth
        } else{
            foreach ($Obj in $PSObjArr) {
                [PSCustomObject]@{
                    Index = $Obj.Index
                    Hex = $Obj.Hex
                    RGB = $Obj.RGB.ToString()
                    HSL = $Obj.HSL.ToString()
                }
            }
        }
    }
}

# $Image = "D:\Dev\Powershell\VSYSModules\VSYSImgOps\bin\DomColorsTestImages\TestImg 06.jpg"
# Get-ImageDominantColors -Path $Image -NumColors 8 -PreviewColors

