# DONE 1

function Convert-RGBToHex {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.HexColor])]
    Param(
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'Individual'
        )]
        [Alias("R")]
        [byte]$Red,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'Individual'
        )]
        [Alias("G")]
        [byte]$Green,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'Individual'
        )]
        [Alias("B")]
        [byte]$Blue,

        [Parameter(
            Mandatory,
            Position = 0,
            ParameterSetName="RGBStruct",
            ValueFromPipeline
        )]
        [VSYSColorStructs.RGBColor[]]$RGBStruct
    )

    Process {

        $RGBToHEX = {
            param ([byte]$R, [byte]$G, [byte]$B)
            $hexRed   = '{0:X2}' -f $R
            $hexGreen = '{0:X2}' -f $G
            $hexBlue  = '{0:X2}' -f $B
            [VSYSColorStructs.HexColor]::new("#$hexRed$hexGreen$hexBlue")
        }

        if($PSCmdlet.ParameterSetName -eq 'Individual'){
            & $RGBToHEX -R $Red -G $Green -B $Blue
        }

        if($PSCmdlet.ParameterSetName -eq 'RGBStruct'){
            foreach($Color in $RGBStruct){
                $Obj = [PSCustomObject]@{
                    R = $Color.R
                    G = $Color.G
                    B = $Color.B
                }
                & $RGBToHEX -R $Obj.R -G $Obj.G -B $Obj.B
            }
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

