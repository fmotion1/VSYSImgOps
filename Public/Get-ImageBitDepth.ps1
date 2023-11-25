function Get-ImageBitDepth {
    [cmdletbinding(DefaultParameterSetName = 'Path')]
    param(
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
        [Switch]
        $ReturnFullFormat,

        [Parameter(Mandatory = $false)]
        [ValidateSet('None', 'PSObject', 'JSON', 'XML', 'Table', IgnoreCase = $true)]
        [String]
        $OutputFormat = 'None'
    )

    begin {

        # Setup return containers
        if($OutputFormat -eq 'PSObject'){ $PSObjContents = @() }
        if($OutputFormat -eq 'Table'){ $TableContents = @() }
        if($OutputFormat -eq 'JSON'){ $JSONContents = @() }
        if($OutputFormat -eq 'XML'){ $XMLContents = @() }
        if($OutputFormat -eq 'NONE'){ $BareContents = @()}
    }

    process {
        # Resolve path(s)
        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            $resolvedPaths = Resolve-Path -Path $Path | Select-Object -ExpandProperty Path
        } elseif ($PSCmdlet.ParameterSetName -eq 'LiteralPath') {
            $resolvedPaths = Resolve-Path -LiteralPath $LiteralPath | Select-Object -ExpandProperty Path
        }

        foreach ($item in $resolvedPaths) {

            try {

                $image = [System.Drawing.Bitmap]::FromFile($item)
                $bitDepth = $image.PixelFormat.ToString()
                $image.Dispose()

                $fullBitDepth = $bitDepth
                if ($bitDepth -match '(\d+)') {
                    $shortBitDepth = $Matches[1]
                }

                $FullObject = [pscustomobject]@{
                    Image     = $item
                    BitDepth  = $fullBitDepth
                }

                $MinimalObject = [pscustomobject]@{
                    Image      = $item
                    BitDepth   = $shortBitDepth
                }

                if($ReturnFullFormat.IsPresent){
                    if($OutputFormat -eq 'PSObject')  { $PSObjContents += $FullObject }
                    elseif($OutputFormat -eq 'JSON')  { $JSONContents  += $FullObject }
                    elseif($OutputFormat -eq 'Table') { $TableContents += $FullObject }
                    elseif($OutputFormat -eq 'XML')   { $XMLContents   += $FullObject }
                    elseif($OutputFormat -eq 'None')  { $BareContents  += $fullBitDepth }
                }
                elseif(!$ReturnFullFormat){
                    if($OutputFormat -eq 'PSObject')  { $PSObjContents += $MinimalObject }
                    elseif($OutputFormat -eq 'JSON')  { $JSONContents  += $MinimalObject }
                    elseif($OutputFormat -eq 'Table') { $TableContents += $MinimalObject }
                    elseif($OutputFormat -eq 'XML')   { $XMLContents   += $MinimalObject }
                    elseif($OutputFormat -eq 'None')  { $BareContents  += $shortBitDepth }
                }
            }
            catch {
                Write-Error "A critical error occured: $_"
                $Error[0] | Format-List * -Force
            }
        }
    }

    end {

        if($OutputFormat -eq 'PSObject'){
            $PSObjContents
        }
        elseif($OutputFormat -eq 'Table'){
            Format-SpectreTable -Data $TableContents -Border Square -Color Grey35
        }
        elseif($OutputFormat -eq 'JSON') {
            $JSONContents | ConvertTo-Json
        }
        elseif($OutputFormat -eq 'XML') {
            ConvertTo-XML -As String -InputObject $XMLContents -Depth 5
        }
        elseif($OutputFormat -eq 'NONE') {
            $BareContents
        }
    }
}

