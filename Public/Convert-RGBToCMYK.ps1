function Convert-RGBToCMYK {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [int]$Red,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [int]$Green,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [int]$Blue
    )

    Process {
        # Convert RGB to CMYK
        if ($Red -eq 0 -and $Green -eq 0 -and $Blue -eq 0) {
            # Black
            return @{
                Cyan = 0
                Magenta = 0
                Yellow = 0
                Key = 100
            }
        } else {
            $c = 1 - ($Red / 255)
            $m = 1 - ($Green / 255)
            $y = 1 - ($Blue / 255)

            $minCMY = [Math]::Min($c, [Math]::Min($m, $y))

            $c = ($c - $minCMY) / (1 - $minCMY) * 100
            $m = ($m - $minCMY) / (1 - $minCMY) * 100
            $y = ($y - $minCMY) / (1 - $minCMY) * 100
            $k = $minCMY * 100

            return @{
                Cyan = [Math]::Round($c, 2)
                Magenta = [Math]::Round($m, 2)
                Yellow = [Math]::Round($y, 2)
                Key = [Math]::Round($k, 2)
            }
        }
    }
}


Convert-RGBToCMYK -Red 20 -Green 255 -Blue 10