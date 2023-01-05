@setlocal ENABLEDELAYEDEXPANSION
@echo OFF

set BASEDIR=%~dp0
cd %BASEDIR%\..
set PROJECTDIR=%CD%

echo
echo Project Dir: %PROJECTDIR%
echo

mkdir target
rsync -avrt --delete ./native/ ./target/
mkdir target\output

@REM can we install visual studio variables?
@call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64 %*

set

cd .\target\tkrzw

@REM we need to swap in VCToolsInstallDir (but it has a trailing slash)
set VCTOOLSDIR=%VCToolsInstallDir:~0,-1%

sed -i -e 's/VCPATH = .*/VCPATH = $(VCTOOLSDIR)/' VCMakefile

cat VCMakefile

nmake -f VCMakefile
