@{
    RootModule = "VSYSImgOps.psm1"
    ModuleVersion = '1.0.0'
    GUID = '5427f8d2-71cf-5d04-9fa0-f8ee2b81f6c0'
    Author = 'Futuremotion'
    CompanyName = 'Futuremotion'
    Copyright = '(c) Futuremotion. All rights reserved.'

    CompatiblePSEditions = @('Core')

    Description = 'Provides automation and other functionality for image manipulation.'
    PowerShellVersion = '7.0'

    CmdletsToExport = @()
    VariablesToExport = '*'
    AliasesToExport = @()
    ScriptsToProcess = @()
    TypesToProcess = @()
    FormatsToProcess = @()
    FileList = @()

    # Leave commented out to import into any host.
    # PowerShellHostName = ''

    RequiredModules =    'PwshSpectreConsole'

    RequiredAssemblies = 'System.Drawing',
                         'System.Windows.Forms', 
                         'PresentationCore', 
                         'PresentationFramework', 
                         'System.Web',
                         "$PSScriptRoot\Lib\VSYSColorStructs.dll"

    FunctionsToExport =  'Get-ImageDominantColors',
                         'Get-ImageDimensions',
                         'Get-ImageBitDepth',
                         'Get-ImageAspectRatio',
                         'Get-ImageFileSize',
                         'Get-ImageOverview',
                         'Convert-HexToRGB',
                         'Convert-HexToHSL',
                         'Convert-HexToHSV',
                         'Convert-RGBToHSL',
                         'Convert-RGBToHSV',
                         'Select-MathMax3Arguments',
                         'Select-MathMin3Arguments',
                         'Confirm-WellFormedHex'
                        

    PrivateData = @{
        PSData = @{
            Tags = @('Image', 'Imaging', 'Photo', 'Processing', 'Automation')
            LicenseUri = 'https://github.com/fmotion1/VSYSImgOps/blob/main/LICENSE'
            ProjectUri = 'https://github.com/fmotion1/VSYSImgOps'
            IconUri = ''
            ReleaseNotes = '1.0.0: (11/6/2023) - Initial Release'
        }
    }
}
