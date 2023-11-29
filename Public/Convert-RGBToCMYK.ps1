# DONE 1

function Convert-RGBToCMYK {
    [CmdletBinding()]
    [OutputType([VSYSColorStructs.CMYKColor])]
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
        [VSYSColorStructs.RGBColor[]]$RGBStruct,

        [Parameter(Mandatory = $false)]
        [ValidateSet(0,1,2,3,4)]
        [Int32]
        $Precision = 2
    )

    Process {

        $RGBToCMYK = {
            param ([byte]$R, [byte]$G, [byte]$B)
            if ($R -eq 0 -and $G -eq 0 -and $B -eq 0) {
                # Black
                return @{
                    Cyan    = 0
                    Magenta = 0
                    Yellow  = 0
                    Key     = 100
                }
            } else {
                $c = 1 - ($R / 255)
                $m = 1 - ($G / 255)
                $y = 1 - ($B / 255)
    
                $minCMY = [Math]::Min($c, [Math]::Min($m, $y))
    
                $c = ($c - $minCMY) / (1 - $minCMY) * 100
                $m = ($m - $minCMY) / (1 - $minCMY) * 100
                $y = ($y - $minCMY) / (1 - $minCMY) * 100
                $k = $minCMY * 100
    
                return @{
                    Cyan    = [Math]::Round($c, $Precision)
                    Magenta = [Math]::Round($m, $Precision)
                    Yellow  = [Math]::Round($y, $Precision)
                    Key     = [Math]::Round($k, $Precision)
                }
            }
        }

        if($PSCmdlet.ParameterSetName -eq 'Individual'){
            & $RGBToCMYK -R $Red -G $Green -B $Blue
        }

        if($PSCmdlet.ParameterSetName -eq 'RGBStruct'){
            foreach($Color in $RGBStruct){
                $Obj = [PSCustomObject]@{
                    R = $Color.R
                    G = $Color.G
                    B = $Color.B
                }
                & $RGBToCMYK -R $Obj.R -G $Obj.G -B $Obj.B
            }
        }
    }
}

#Convert-RGBToCMYK -Red 170 -Green 60 -Blue 90