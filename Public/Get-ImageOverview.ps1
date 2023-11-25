function Get-ImageOverview {

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

        [Parameter(Mandatory=$false)]
        [ValidateSet('PSObject','JSON','XML','TABLE', IgnoreCase = $true)]
        [String]
        $OutputFormat = 'PSObject'

    )

    begin {
        # Init
        $PSObjContents = @()
    }

    process {

        # Resolve path(s)
        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            $resolvedPaths = Resolve-Path -Path $Path | Select-Object -ExpandProperty Path
        } elseif ($PSCmdlet.ParameterSetName -eq 'LiteralPath') {
            $resolvedPaths = Resolve-Path -LiteralPath $LiteralPath | Select-Object -ExpandProperty Path
        }

        # Process each item in resolved paths
        foreach ($item in $resolvedPaths) {

            $W = Get-ImageDimensions -Path $item -WidthOnly
            $H = Get-ImageDimensions -Path $item -HeightOnly
            $B = Get-ImageBitDepth -Path $item -OutputFormat None
            $A = Get-ImageAspectRatio -Path $item
            $S = Get-ImageFileSize -Path $item -OutputUnits Auto

            $ReturnObject = [PSCustomObject]@{
                File        = $item
                Width       = $W
                Height      = $H
                BitDepth    = $B
                AspectRatio = $A
                FileSize    = $S
            }

            $PSObjContents += $ReturnObject

        }
    }

    end {
        if($OutputFormat -eq 'PSObject'){
            $PSObjContents
        }
        elseif($OutputFormat -eq 'JSON'){
            $PSObjContents | ConvertTo-Json
        }
        elseif($OutputFormat -eq 'XML'){
            ConvertTo-XML -As String -InputObject $PSObjContents -Depth 5
        }
        elseif($OutputFormat -eq 'TABLE'){
            Format-SpectreTable -Data $PSObjContents -Border Square -Color Grey35
        }
    }
}