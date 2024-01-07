function Convert-CropSVGInkscapeFolder {
    [cmdletbinding(DefaultParameterSetName = 'Path')]
    param(
        [parameter(
            Mandatory,
            ParameterSetName  = 'Path',
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

        [Switch] $RenameOutput,
        [Switch] $PlaceInSubfolder,
        [Int32] $MaxThreads = 16

    )

    process {
        
        $List = [System.Collections.Generic.List[String]]@()

        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            $ResolvedPaths = Resolve-Path -Path $Path | Select-Object -ExpandProperty Path
        } elseif ($PSCmdlet.ParameterSetName -eq 'LiteralPath') {
            $ResolvedPaths = Resolve-Path -LiteralPath $LiteralPath | Select-Object -ExpandProperty Path
        }

        foreach ($Path in $ResolvedPaths) {
            if(Test-Path -LiteralPath $Path -PathType Container){
                $List.Add($Path)
            }
        }

        $List | ForEach-Object {
            $Files = Get-ChildItem -LiteralPath $_ -Filter *.svg -Depth 0 | % {$_.FullName}
            $convertCropSVGInkscapeSplat = @{
                Files = $Files
                RenameOutput = $RenameOutput
                PlaceInSubfolder = $PlaceInSubfolder
                MaxThreads = $MaxThreads
            }
            Convert-CropSVGInkscape @convertCropSVGInkscapeSplat 
        }
    }
}
