Push-Location $PSScriptRoot -StackName DotnetBuild
dotnet build .\VSYSColorStructs.csproj --configuration Debug
Pop-Location -StackName DotnetBuild
