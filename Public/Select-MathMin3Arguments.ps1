function Select-MathMin3Arguments {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [array]$Values
    )

    if(($Values.Count -gt 3) -or ($Values.Count -lt 3)){
        Write-Error "Incorrect number of values passed. This function takes exactly three values."
        return
    }

    $Val1, $Val2, $Val3 = $Values

    $min = $Val1
    if ($Val2 -lt $min) { $min = $Val2 }
    if ($Val3 -lt $min) { $min = $Val3 }
    return $min
}