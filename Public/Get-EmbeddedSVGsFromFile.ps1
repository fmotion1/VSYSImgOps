using namespace System.Text.RegularExpressions

function Get-EmbeddedSVGsFromFile {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [String[]] $TargetFiles
    )

    process {

        $TargetFiles | ForEach-Object {

            $TargetFile = $_
            $TargetFileNoExt = $TargetFile.Substring(0, $TargetFile.LastIndexOf('.'))
            $TargetFileBase = ([System.IO.Path]::GetFileNameWithoutExtension($TargetFile)) -replace ' ', ''
            $OutputFolder = $TargetFileNoExt + " Extracted SVGs"
            
            if(-not($OutputFolder | Test-Path)){
                New-Item $OutputFolder -ItemType Directory -Force    
            }

            $rInput = Get-Content -Path $TargetFile -Raw
            
            $reUTF8Pattern = '(data:image/svg\+xml;charset=utf-8,)(%3Csvg)(.*?)(/svg%3E)'
            $reBase64Pattern = '(?:data:image/svg\+xml;base64,)([a-zA-Z0-9]+)([=]{1,2})'
            $reInlinePattern = '<\s*svg[^>]*>(.*?)<\s*/\s*svg>'

            ### TODO: Add support for automatically downloading linked SVGs.

            $reUTF8 = [regex]$reUTF8Pattern
            [MatchCollection]$UTF8Matches = $reUTF8.Matches($rInput)
            foreach ($m in $UTF8Matches) {
                $UTF8encodedOpenTag  = $m.Groups[2].Value
                $UTF8encodedContent  = $m.Groups[3].Value
                $UTF8encodedCloseTag = $m.Groups[4].Value
                $UTF8encodedSVG = $UTF8encodedOpenTag + $UTF8encodedContent + $UTF8encodedCloseTag
                $UTF8decodedSVG = [System.Web.HttpUtility]::UrlDecode($UTF8encodedSVG)
                
                $RND = Get-RandomAlphanumericString -Length 14
                $NewFilename = $TargetFileBase + "_" + $RND + '.svg'
                $DestPath = Join-Path $OutputFolder $NewFilename
                
                Set-Content $DestPath $UTF8decodedSVG -Encoding UTF8 | Out-Null
            }

            $reB64 = [regex]$reBase64Pattern
            [MatchCollection]$B64Matches = $reB64.Matches($rInput)
            foreach ($m in $B64Matches) {

                $Base64DataBody = $m.Groups[1].Value
                $Base64DataEnd = $m.Groups[2].Value
                $Base64SVG = $Base64DataBody + $Base64DataEnd
                $Base64SVGBytes = [Convert]::FromBase64String($Base64SVG)
                $Base64DecodedSVG = [Text.Encoding]::UTF8.GetString($Base64SVGBytes)

                $RND = Get-RandomAlphanumericString -Length 14
                $NewFilename = $TargetFileBase + "_" + $RND + '.svg'
                $DestPath = Join-Path $OutputFolder $NewFilename
                
                Set-Content $DestPath $Base64DecodedSVG -Encoding UTF8 | Out-Null
            }
            
            $reInline = [regex]$reInlinePattern
            [MatchCollection]$InlineMatches = $reInline.Matches($rInput)
            foreach ($m in $InlineMatches) {

                $InlineSVG = $m.Groups[0].Value
                
                $RND = Get-RandomAlphanumericString -Length 14
                $NewFilename = $TargetFileBase + "_" + $RND + '.svg'
                $DestPath = Join-Path $OutputFolder $NewFilename
                
                Set-Content $DestPath $InlineSVG -Encoding UTF8 | Out-Null
            }
        }

        $NVMIsPresent = $false
        try {
            $NVMCmd = Get-Command nvm.exe -CommandType Application
            $NVMIsPresent = $true
        }
        catch {
            Write-Error "NVM Can't be found in PATH."
            $NVMIsPresent = $false
        }
        if(-not($NVMIsPresent)){
            try {
                $SVGOCmd = Get-Command svgo.cmd
            }
            catch {
                Write-Error "SVGO isn't installed, aborting cleanup."    
            }
        }else{
            $LatestVersion = Get-LatestNodeWithNVM
            & $NVMCmd use $LatestVersion

            try {
                $SVGOCmd = Get-Command svgo.cmd
            }
            catch {
                Write-Error "SVGO isn't installed, aborting cleanup."
                return
            }

            & $SVGOCmd -f $OutputFolder | Out-Null
        }

        Write-Host "SVG Extraction Process Complete." -ForegroundColor White
        Write-Host -NoNewLine 'Press any key to exit.'
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    }
}