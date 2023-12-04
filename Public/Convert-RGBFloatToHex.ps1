# DONE 1
function Convert-RGBFloatToHex {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.HTMLHex])]
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
            ParameterSetName="RGBFloat",
            ValueFromPipeline
        )]
        [VSYSColorStructs.RGBFloat[]]$RGBFloat

    )

    Process {

        $RGBFloatToHEX = {
            param ([double]$R, [double]$G, [double]$B)
            [byte]$RByte = (($R * 256) -as [byte])
            [byte]$GByte = (($G * 256) -as [byte])
            [byte]$BByte = (($B * 256) -as [byte])
            $hR = '{0:X2}' -f $RByte
            $hG = '{0:X2}' -f $GByte
            $hB = '{0:X2}' -f $BByte
            [VSYSColorStructs.HexColor]::new("#$hR$hG$hB")
        }

        if($PSCmdlet.ParameterSetName -eq 'Individual'){
            & $RGBFloatToHEX -R $Red -G $Green -B $Blue
        }

        if($PSCmdlet.ParameterSetName -eq 'PSObject'){
            & $RGBFloatToHEX -R $PSObject.R -G $PSObject.G -B $PSObject.B
        }

        if($PSCmdlet.ParameterSetName -eq 'RGBFloat'){
            & $RGBFloatToHEX -R $RGBFloat.Red -G $RGBFloat.Green -B $RGBFloat.Blue 
        }
    }
}




# # Individual
# Convert-RGBToHex -Red 120 -Green 10 -Blue 60

# # Struct
# $Struct = [VSYSColorStructs.RGBColor]::new(127,60,30)
# Convert-RGBToHex $Struct

# # Struct Pipe
# $Struct = [VSYSColorStructs.RGBColor]::new(127,60,30)
# $Struct | Convert-RGBToHex

# [PSCustomObject]@{ R = 120; G = 30; B = 155 } | Convert-RGBToHex

