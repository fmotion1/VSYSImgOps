function Get-ImageFileSize {

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
        [ValidateSet('Bytes','KB','MB','Auto',IgnoreCase=$true)]
        [String]
        $OutputUnits = 'Auto',

        [Parameter(Mandatory=$false)]
        [int32]
        $Precision = 2,

        [Parameter(Mandatory=$false)]
        [ValidateSet('None','PSObject','JSON','XML','Table', IgnoreCase = $true)]
        [String]
        $OutputFormat = 'None',

        [Parameter(Mandatory=$false)]
        [ValidateSet('Combined','Separated', IgnoreCase = $true)]
        [String]
        $FormatUnits = 'Combined',

        [Parameter(Mandatory=$false)]
        [Switch]
        $HideDefaultUnitLabels

    )

    begin {

        # Parameter Validation
        if($Precision -gt 15){
            Write-Error "Precision must be between 0 and 15."
            return 2
        }

        if(($OutputFormat -ne 'None') -and ($HideDefaultUnitLabels)){
            Write-Error "HideDefaultUnitLabels is only usable if the output format is NONE."
            return 2
        }

        # Setup return containers
        if($OutputFormat -eq 'PSObject'){ $PSObjContents = @() }
        if($OutputFormat -eq 'Table'){ $TableContents = @() }
        if($OutputFormat -eq 'JSON'){ $JSONContents = @() }
        if($OutputFormat -eq 'XML'){ $XMLContents = @() }
        if($OutputFormat -eq 'NONE'){ $DefaultUnits = @() }
    }

    process {

        # Resolve path(s)
        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            $resolvedPaths = Resolve-Path -Path $Path | Select-Object -ExpandProperty Path
        } elseif ($PSCmdlet.ParameterSetName -eq 'LiteralPath') {
            $resolvedPaths = Resolve-Path -LiteralPath $LiteralPath | Select-Object -ExpandProperty Path
        }

        # Iterate
        foreach ($item in $resolvedPaths) {
            try {
                $file = Get-Item -LiteralPath $item
                $fileSizeBytes = $file.Length
                [decimal]$fileSize = 0

                if($OutputUnits -eq 'Bytes'){
                    $fileSize = $file.Length
                    $UnitLabel = 'Bytes'
                }
                elseif($OutputUnits -eq 'KB'){
                    $fileSize = [math]::Round($fileSizeBytes / 1024, $Precision)
                    $UnitLabel = 'KB'
                }
                elseif($OutputUnits -eq 'MB'){
                    $fileSize = [math]::Round($fileSizeBytes / 1048576, $Precision)
                    $UnitLabel = 'MB'
                }
                elseif($OutputUnits -eq 'Auto'){
                    if ($fileSizeBytes -lt 1024) {
                        $fileSize = $file.Length
                        $UnitLabel = 'Bytes'
                    }
                    if ($fileSizeBytes -lt 1048576) {
                        $fileSize = [math]::Round($fileSizeBytes / 1024, $Precision)
                        $unitLabel = "KB"
                    }
                    else {
                        $fileSize = [math]::Round($fileSizeBytes / 1048576, $Precision)
                        $unitLabel = "MB"
                    }
                }

                $SeparatedValues = [pscustomobject]@{
                    File  = $item
                    Size  = $fileSize
                    Unit  = $unitLabel
                }

                $CombinedValues = [pscustomobject]@{
                    File  = $item
                    Size  = "$fileSize $unitLabel"
                }

                if($FormatUnits -eq 'Combined'){
                    if($OutputFormat -eq 'PSObject')  { $PSObjContents += $CombinedValues }
                    elseif($OutputFormat -eq 'JSON')  { $JSONContents  += $CombinedValues }
                    elseif($OutputFormat -eq 'Table') { $TableContents += $CombinedValues }
                    elseif($OutputFormat -eq 'XML')   { $XMLContents   += $CombinedValues }
                }
                elseif($FormatUnits -eq 'Separated'){
                    if($OutputFormat -eq 'PSObject')  { $PSObjContents += $SeparatedValues }
                    elseif($OutputFormat -eq 'JSON')  { $JSONContents  += $SeparatedValues }
                    elseif($OutputFormat -eq 'Table') { $TableContents += $SeparatedValues }
                    elseif($OutputFormat -eq 'XML')   { $XMLContents   += $SeparatedValues }
                }

                if($OutputFormat -eq 'None')  {
                    if($HideDefaultUnitLabels){
                        $DefaultUnits  += $fileSize
                    }
                    else {
                        $DefaultUnits  += "$fileSize $unitLabel"
                    }
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
            $DefaultUnits
        }
    }
}

# Get-ImageFileSize -LiteralPath "C:\Wallpapers\Dump\g4mebjee1aw81.png"