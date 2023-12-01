# IN PROGRESS

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
            ParameterSetName = 'String'
        )]
        [String[]]$String,

        [Parameter(
            Mandatory,
            Position = 0,
            ParameterSetName="RGBByteStruct",
            ValueFromPipeline
        )]
        [VSYSColorStructs.RGBByte[]]$RGBByteStruct
    )

    Process {

        $RGBToCMYK = {

            #param ([byte]$R, [byte]$G, [byte]$B)
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

        if($PSCmdlet.ParameterSetName -eq 'String'){
            foreach ($Str in $String) {
                $StrArr = $Str.Split(',')
            }
            & $RGBToCMYK -R $StrArr[0] -G $StrArr[1] -B $StrArr[2]
        }

        if($PSCmdlet.ParameterSetName -eq 'RGBByteStruct'){
            & $RGBToCMYK -R $RGBByteStruct.Red -G $RGBByteStruct.Green -B $RGBByteStruct.Blue
        }
    }
}

# Convert-RGBToCMYK -r 200 -g 140 -b 200


# $PSO1 = [PSCustomObject]@{ R = 200; G = 150; B = 90; }
# $PSO2 = [PSCustomObject]@{ R = 60; G = 70; B = 252; }
# $PSO1, $PSO2 | Convert-RGBToCMYK

# $S1 = [VSYSColorStructs.RGBByte]::new(200,180,255)
# Convert-RGBToCMYK -RGBByteStruct $S1

# $S2 = [VSYSColorStructs.RGBByte]::new(1,2,3)
# $S2 | Convert-RGBToCMYK

# Convert-RGBToCMYK -Red 170 -Green 60 -Blue 90
