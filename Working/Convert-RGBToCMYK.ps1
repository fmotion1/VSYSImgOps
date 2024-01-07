# DONE 3

function Convert-RGBToCMYK {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.CMYK])]
    Param(
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'Individual'
        )]
        [Alias("Red")]
        [double]$R,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'Individual'
        )]
        [Alias("Green")]
        [double]$G,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'Individual'
        )]
        [Alias("Blue")]
        [double]$B,

        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'PSObject'
        )]
        [PSCustomObject[]]$PSObject,

        [Parameter(
            Mandatory,
            Position = 0,
            ParameterSetName="RGBByte",
            ValueFromPipeline
        )]
        [VSYSColorStructs.RGBByte[]]$RGBByte,

        [Parameter(
            Mandatory,
            Position = 0,
            ParameterSetName="RGBFloat",
            ValueFromPipeline
        )]
        [VSYSColorStructs.RGBFloat[]]$RGBFloat
    )

    Process {

        $RGBToCMYK = {

            param ([double]$R, [double]$G, [double]$B)

            if ($R -eq 0 -and $G -eq 0 -and $B -eq 0) {

                [VSYSColorStructs.CMYK]::new(0, 0, 0, 100)

            } else {

                $Cyan = 1 - ($R / 255)
                $Magenta = 1 - ($G / 255)
                $Yellow = 1 - ($B / 255)

                $minCMY = [Math]::Min($Cyan, [Math]::Min($Magenta, $Yellow))
                $Cyan    = ($Cyan - $minCMY) / (1 - $minCMY) * 100
                $Magenta = ($Magenta - $minCMY) / (1 - $minCMY) * 100
                $Yellow  = ($Yellow - $minCMY) / (1 - $minCMY) * 100
                $Key = $minCMY * 100

                [VSYSColorStructs.CMYK]::new($Cyan, $Magenta, $Yellow, $Key)

            }
        }

        if($PSCmdlet.ParameterSetName -eq 'Individual'){
            & $RGBToCMYK -R $R -G $G -B $B
        }

        if($PSCmdlet.ParameterSetName -eq 'PSObject'){
            & $RGBToCMYK -R $PSObject.R -G $PSObject.G -B $PSObject.B
        }

        if($PSCmdlet.ParameterSetName -eq 'RGBByte'){
            & $RGBToCMYK -R $RGBByte.Red -G $RGBByte.Green -B $RGBByte.Blue
        }

        if($PSCmdlet.ParameterSetName -eq 'RGBFloat'){
            & $RGBToCMYK -R $RGBFloat.Red -G $RGBFloat.Green -B $RGBFloat.Blue
        }
    }
}

# Convert-RGBToCMYK -r 200 -g 140 -b 200

# $PSO1 = [PSCustomObject]@{ R = 200; G = 150; B = 90; }
# $PSO2 = [PSCustomObject]@{ R = 60; G = 70; B = 252; }
# $PSO1, $PSO2 | Convert-RGBToCMYK

# $S1 = [VSYSColorStructs.RGBByte]::new(200,180,255)
# $S2 = [VSYSColorStructs.RGBByte]::new(1,2,3)
# $S1, $S2 | Convert-RGBToCMYK

# $Float = [VSYSColorStructs.RGBFloat]::new(.84534, .23447, .954)
# $Float | Convert-RGBToCMYK

# Convert-RGBToCMYK -Red 170 -Green 60 -Blue 90
