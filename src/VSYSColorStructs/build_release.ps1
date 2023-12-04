Push-Location $PSScriptRoot -StackName DotnetBuild
dotnet build .\VSYSColorStructs.csproj --configuration Release
Pop-Location -StackName DotnetBuild
