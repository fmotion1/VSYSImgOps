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
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string[]]$Path,

        [parameter(
            Mandatory,
            ParameterSetName = 'LiteralPath',
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('PSPath')]
        [string[]]$LiteralPath,

        [Parameter(Mandatory = $false)]
        [Int32]
        $PreResize = 200,

        [Parameter(Mandatory=$false)]
        [Alias("c")]
        [Int32]
        $NumColors,

        [Parameter(Mandatory = $false)]
        [ValidateSet('None', 'PSObjectArray', 'JSON', 'XML', 'Table', 'Array', IgnoreCase = $true)]
        [String]
        $OutputFormat = 'None',

        [Parameter(Mandatory=$false)]
        [Switch]
        $PreviewColors,

        [Parameter(Mandatory = $false)]
        [Int32]
        $PreviewColorWidth = 120,

        [Parameter(Mandatory = $false)]
        [Switch]
        $PreviewNoLabel
    )

    begin {

        if(($NumColors -lt 2) -or ($NumColors -gt 15)){
            Write-Error "Invalid number of colors. Range is 2-15."
            return 2
        }

        # Setup return containers
        if($OutputFormat -eq 'PSObject'){ $PSObjContents = @() }
        if($OutputFormat -eq 'Table'){ $TableContents = @() }
        if($OutputFormat -eq 'JSON'){ $JSONContents = @() }
        if($OutputFormat -eq 'XML'){ $XMLContents = @() }
        if($OutputFormat -eq 'NONE'){ $BareContents = @() }
        if($OutputFormat -eq 'Array'){ $ArrayContents = @() }

        $FinalColorList = @()


    }

    process {

        & "$PSScriptRoot\..\bin\DomColorsVENV\Scripts\Activate.ps1"
        $Script = "$PSScriptRoot\..\bin\DomColorsScripts\domcolorsMain.py"
        $PYCMD  = "$PSScriptRoot\..\bin\DomColorsVENV\Scripts\python.exe"
        $Params = $Script, '-i', $Path, '-r', $PreResize, '-n', $NumColors, '-o', 'List'
        $Colors = & $PYCMD $Params

        $FinalColorList = $Colors

        if($OutputFormat -eq 'None'){
            return $FinalColorList
        }
        elseif($OutputFormat -eq 'PSObjectArray'){

            $ObjArr = @()
            
            for ($idx = 0; $idx -eq $FinalColorList.Count; $idx++) {
                $HexColor = $FinalColorList[$idx]
                $RGBValues = Convert-HexToRGB -HexColor $HexColor
                
                $ObjTemp = [PSCustomObject]@{
                    ColorIndex = $idx
                    Hex = $FinalColorList[$idx]
                    RGB = "$($RGBValues.Red),$($RGBValues.Green),$($RGBValues.Blue)"
                    HSL = $RGBValues.Green
                    B = $RGBValues.Blue
                }
            }
        }


    }

    end {

        & deactivate

        if($PreviewColors){
            $ColorObjects = @()
            for ($idx = 0; $idx -lt $FinalColorList.Count; $idx++) {

                if($PreviewNoLabel){ $LabelVal = '' }
                else{ $LabelVal = $FinalColorList[$idx] }

                $ColorObjects += @{ Label = $LabelVal; Value = 1; Color = $FinalColorList[$idx] }
            }

            Format-SpectreBreakdownChart -Data $ColorObjects -Width 100
        }


    }

}

# $Image = 'D:\Dev\Powershell\VSYSModules\VSYSImgOps\bin\DomColorsTestImages\TestImg 02.jpg'
# $Colors = Get-ImageDominantColors -Path $Image -NumColors 8 -PreviewColors -PreviewNoLabel
# Write-Host "`$Colors:" $Colors -ForegroundColor Green

