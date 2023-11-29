function Get-ImageDominantColorsColorthief {
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

        [Parameter(Mandatory=$false)]
        [Int32]
        $NumColors = 6,

        # Quality: 1 is the highest quality. 
        [Parameter(Mandatory = $false)]
        [ValidateSet('Best','High','Medium','Low','Very Low', IgnoreCase = $true)]
        [String]
        $Quality = 'Best',

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
        if($OutputFormat -eq 'Table')   { $TableContents = @() }
        if($OutputFormat -eq 'JSON')    { $JSONContents  = @() }
        if($OutputFormat -eq 'XML')     { $XMLContents   = @() }
        if($OutputFormat -eq 'NONE')    { $BareContents  = @() }
        if($OutputFormat -eq 'Array')   { $ArrayContents = @() }
        $FinalColorList = @()
    }

    process {

        & "$PSScriptRoot\..\bin\DomColorsVENV\Scripts\Activate.ps1"
        $PYCMD  = Resolve-Path -Path "$PSScriptRoot\..\bin\DomColorsVENV\Scripts\python.exe"
        $Script = Resolve-Path -Path "$PSScriptRoot\..\bin\DomColorsScripts\colorthiefMain.py"
        
        [int32]$QualityNum = switch ($Quality) {
            "Best"     {1; break}
            "High"     {2; break}
            "Medium"   {3; break}
            "Low"	   {4; break}
            "Very Low" {5; break}
        }

        $Params = $Script, '-i', $Path, '-q', $QualityNum, '-n', $NumColors
        $PaletteArr = & $PYCMD $Params

        $sArr = $PaletteArr -replace '^\[|\]$' -split '\), \('

        $resultArray = @()
        $sArr | ForEach-Object {
            $tupleString = $_ -replace '^\(|\)$'
            $resultArray += $tupleString

            # $resultArray = $tupleString -split ', ' #| ForEach-Object { [int]$_ }
        }

        if($OutputFormat -eq 'None'){
            $resultArray

        }
        elseif($OutputFormat -eq 'PSObjectArray'){
            $PSArr = @()
            
        }
        #[PSCustomObject]@{R = $tupleArray[0]; G = $tupleArray[1]; B = $tupleArray[2]}

        #$resultArray

    }

    end {
        & deactivate
    }
}

#Get-ImageDominantColorsColorthief -Path "D:\Dev\Python\dom_colors\img\TestImg 11.jpg" -NumColors 6 -Quality Best -OutputFormat None