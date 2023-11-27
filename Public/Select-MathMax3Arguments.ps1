function Select-MathMax3Arguments {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [array]$Values
    )

    if(($Values.Count -gt 3) -or ($Values.Count -lt 3)){
        Write-Error "Incorrect number of values passed. This function takes exactly three values."
        return
    }

    $Val1, $Val2, $Val3 = $Values

    $max = $Val1
    if ($Val2 -gt $max) { $max = $Val2 }
    if ($Val3 -gt $max) { $max = $Val3 }
    return $max
}