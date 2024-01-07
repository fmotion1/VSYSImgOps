function Convert-SVGtoICOFolder {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        $Folders,
        [Switch] $HonorSub16pxSizes,
        [Int32] $MaxThreads = 16
    )

    begin {
        $List = [System.Collections.Generic.List[string]]@()
    }

    process {

        foreach ($P in $Folders) {

            $Path = if ($P -is [String])  { $P }
                    elseif ($P.Path)	  { $P.Path }
                    elseif ($P.FullName)  { $P.FullName }
                    elseif ($P.PSPath)	  { $P.PSPath }
                    else { Write-Error "$P is an unsupported type."; throw }

            $AbsolutePath = if ([System.IO.Path]::IsPathRooted($Path)) { $Path }
            else { Resolve-Path -Path $Path }

            if (Test-Path -Path $AbsolutePath -PathType Container) {
                $List.Add($AbsolutePath)
            } else {
                Write-Warning "$AbsolutePath does not exist."
            }
        }

        $List | ForEach-Object {
            $Files = Get-ChildItem -LiteralPath $_ -Depth 0 | % {$_.FullName}
            Convert-SVGtoICO -Files $Files -HonorSub16pxSizes:$HonorSub16pxSizes -MaxThreads $MaxThreads
        }
    }
}