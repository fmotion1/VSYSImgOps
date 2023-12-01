# function FloatToByte1 {
#     param ($f)
#     $b = ($f -ge 1.0) ? 255 : ( ($f -le 0.0) ? 0 : [Int32]([System.Math]::Floor($f * 256.0)) )
#     return $b
# }

# function FloatToByte2 {
#     param ($f)
#     $v2 = ([System.Math]::Floor($f * 256.0)) -as [Int32]
#     $b = [System.Math]::Min(255, $v2)
    
    
# }


# function FloatsToHex {
#     [OutputType([VSYSColorStructs])]
#     [CmdletBinding()]
#     param (

#         $r, $g, $b
#     )
#     $RVal = [System.Convert]::ToString([System.Convert]::ToInt32($r*255),16)
#     $GVal = [System.Convert]::ToString([System.Convert]::ToInt32($g*255),16)
#     $BVal = [System.Convert]::ToString([System.Convert]::ToInt32($b*255),16)
#     return "#$RVal$GVal$BVal"
# }

# HexToFloats -h '#F6F6F6'

# FloatsToHex -r 0.964705882352941 -g 0.964705882352941 -b 0.964705882352941

# FloatToByte1 -f .96
# FloatToByte1 -f .96
# FloatToByte1 -f .96


# FloatToByte2 -f .96
# FloatToByte2 -f .96
# FloatToByte2 -f .96

#Write-Host "`$b:" $b -ForegroundColor Green

#$R = (0.80 * 255.999) -as [int32]
#$G = (0.08 * 255.999) -as [int32]
#$B = (0.09 * 255.999) -as [int32]
#Write-Host "`$R:" $R -ForegroundColor Green
#Write-Host "`$G:" $G -ForegroundColor Green
#Write-Host "`$B:" $B -ForegroundColor Green
# $Val.ToString()