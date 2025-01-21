#Requires -Version 5.0

$basedir = $PSScriptRoot
$project_dir = [IO.Path]::GetFullPath("$basedir\..")

$buildos = $args[0]
$buildarch = $args[1]

Write-Host "Base dir: $basedir"
Write-Output "Build OS: $buildos"
Write-Output "Build arch: $buildarch"

if ([string]::IsNullOrEmpty($buildos)) {
    Write-Output "Build os was emptpy"
    exit 1
}

if ([string]::IsNullOrEmpty($buildarch)) {
    Write-Output "Build arch was emptpy"
    exit 1
}

Remove-Item -LiteralPath "$project_dir\target" -Force -Recurse
Copy-Item -Path "$project_dir\native" -Destination "$project_dir\target" -Recurse

$vcarch = "x64"
if ($buildarch -eq "arm64") {
    $vcarch = "x64_arm64"
}

Write-Output "Loading vcvarsall.bat for environment variables..."

$cmd = "`"C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat`" $vcarch & set"
cmd /c $cmd | Foreach-Object {
    if ($_ -match "^(.*?)=(.*)$") {
        $name = $matches[1]
        $value = $matches[2]
        #Write-Output "Setting env:$name = $value"
        Set-Item "env:$name" $value
    }
}

Write-Output "Tweaking tkzrw VCMakefile to match current environment..."

# fix VCMakefile to the current environment
$windowsVersionTarget = "0x0601"
$vcPath = $env:VCToolsInstallDir
$vcPath = $vcPath.Substring(0, $vcPath.Length - 1)
$sdkPath = "$env:WindowsSdkDir" + "Lib\$env:WindowsSDKLibVersion"

$vcMakefilePath = "$project_dir\target\tkrzw\VCMakefile"
$vcMakeFile = [IO.File]::ReadAllText($vcMakefilePath)
$vcMakeFile = $vcMakeFile -replace "VCPATH = .*`n", "VCPATH = $vcPath`n`n"
$vcMakeFile = $vcMakeFile -replace "SDKPATH = .*`n", "SDKPATH = $sdkPath`n`n"
$vcMakeFile = $vcMakeFile -replace "CLFLAGS = .*`n", "CLFLAGS = /nologo /DWINVER=$windowsVersionTarget /D_WIN32_WINNT=$windowsVersionTarget \`n"
$vcMakeFile = $vcMakeFile -replace "\\x64", "\$buildarch"
$vcMakeFile = $vcMakeFile -replace "PREFIX = .*`n", "PREFIX = $project_dir\target`n`n"
Set-Content -Path $vcMakefilePath -Value $vcMakeFile

Set-Location "$project_dir\target\tkrzw"

nmake -f VCMakefile

Set-Location $project_dir


Write-Output "Tweaking tkzrw-java VCMakefile to match current environment..."

$vcMakefilePath = "$project_dir\target\tkrzw-java\VCMakefile"
Copy-Item "$project_dir\setup\VCMakefile-jtkrzw" $vcMakefilePath
$vcMakeFile = [IO.File]::ReadAllText($vcMakefilePath)
$vcMakeFile = $vcMakeFile -replace "VCPATH = .*`n", "VCPATH = $vcPath`n`n"
$vcMakeFile = $vcMakeFile -replace "SDKPATH = .*`n", "SDKPATH = $sdkPath`n`n"
$vcMakeFile = $vcMakeFile -replace "CLFLAGS = .*`n", "CLFLAGS = /nologo /DWINVER=$windowsVersionTarget /D_WIN32_WINNT=$windowsVersionTarget \`n"
$vcMakeFile = $vcMakeFile -replace "\\x64", "\$buildarch"
$vcMakeFile = $vcMakeFile -replace "PREFIX = .*`n", "PREFIX = $project_dir\target`n`n"
Set-Content -Path $vcMakefilePath -Value $vcMakeFile

Set-Location "$project_dir\target\tkrzw-java"

nmake -f VCMakefile

Copy-Item ".\jtkrzw.dll" "..\..\tkrzw-$buildos-$buildarch\src\main\resources\jne\$buildos\$buildarch\"

Set-Location $project_dir