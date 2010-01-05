!include "MUI2.nsh"
!include "TextFunc.nsh"

!define MUI_ICON nsis\icon.ico
!define MUI_INSTALLCOLORS "DDDDDD 333333"
!define MUI_INSTFILESPAGE_COLORS "DDDDDD 333333"
!define MUI_INSTFILESPAGE_PROGRESSBAR colored
!define NAME 'm0d_s0beit_sa'
!define MP 'SA-MP'
!define MP_VERSION 'v0.3a'
!define /date COMPILE_DATE "%Y-%m-%d"
!define /date COMPILE_TIME "%H-%M-%S"
!define VERSION 'DEV'
!define VERSION_DT '${VERSION}.${COMPILE_DATE}.${COMPILE_TIME}'

; get SVN revision for development version message
!system '".\get_svn_revision.bat"'
!searchparse /ignorecase /noerrors /file ".\svnrev.txt" '' SVNREVTEMP
!searchparse /ignorecase /noerrors /file ".\svnrev.txt" ':' SVNREVTEMP
!ifndef SVNREVTEMP
	!define SVNREV 'FAIL'
!else
	!searchreplace /ignorecase SVNREV "${SVNREVTEMP}" "exported" "FAIL"
!endif

Name "${NAME} ${MP} ${MP_VERSION} ${VERSION}"
OutFile "..\_DEV_installers\${NAME}.${MP}.${VERSION_DT}.SVN.${SVNREV}.Setup.exe"
SetCompressor /SOLID lzma
CRCCheck force
BrandingText /TRIMCENTER "Visit ${NAME} at Google Code, Click Here"
ShowInstDetails show
ShowUninstDetails show
RequestExecutionLevel admin

; gimme some mo plugins
!addplugindir ".\nsis"

!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit
Function onGUIInit
 BrandingURL::Set /NOUNLOAD "0" "0" "200" "http://code.google.com/p/m0d-s0beit-sa/"
FunctionEnd

Page directory
DirText "Welcome to the installer for ${NAME} ${VERSION} for ${MP} ${MP_VERSION}.$\r$\n$\r$\nThis is a development version built from SVN Revision #${SVNREV}$\r$\n$\r$\nCheck out ${NAME} at Google Code for the lastest versions and information.  Just click the link on the bottom left." "Please select your GTA San Andreas directory."
InstallDirRegKey HKLM "SOFTWARE\Rockstar Games\GTA San Andreas\Installation" ExePath
Function .onVerifyInstDir
	IfFileExists $INSTDIR\gta_sa.exe +2
		Abort
FunctionEnd

!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

Section "Install" SecDummy
	DetailPrint "Log created by ${NAME} ${VERSION} for ${MP} ${MP_VERSION} setup."

	SetOutPath "$INSTDIR"
	SetOverwrite on

	; delete old crap
	Delete samp.dll.bak
	Delete s0beit_hack.ini
	Delete s0beit_hack.log
	Delete s0beit_hack_a3v5.raw
	Delete m0d_s0beit_sa.raw
	Delete m0d_s0beit_sa_setup.log

	File ..\bin\d3d9.dll
	File ..\bin\m0d_s0beit_sa.raw
	File ..\bin\speedo.png
	File ..\bin\needle.png

	; need to figure out how to patch this instead of overwriting every time
	File ..\bin\m0d_s0beit_sa.ini

	SetOutPath "$INSTDIR\data"
	SetOverwrite off
	File ..\bin\data\carmods.two
	File ..\bin\data\default.two
	File ..\bin\data\handling.two
	File ..\bin\data\shopping.two
	File ..\bin\data\timecyc.two
	File ..\bin\data\vehicles.two
	File ..\bin\data\surface.two
	SetOverwrite on

	SetOutPath "$INSTDIR\screenshots"

	WriteUninstaller "$INSTDIR\Uninstall_${NAME}.exe"
	DetailPrint "${NAME} ${VERSION} for ${MP} ${MP_VERSION} setup finished."
	DumpLog::DumpLog "$INSTDIR\m0d_s0beit_sa_setup.log" .R0
SectionEnd

Section "Uninstall"
	Delete "$INSTDIR\d3d9.dll"
	Delete "$INSTDIR\m0d_s0beit_sa.log"
	Delete "$INSTDIR\m0d_s0beit_sa_all.log"
	Delete "$INSTDIR\m0d_s0beit_sa.raw"
	Delete "$INSTDIR\speedo.png"
	Delete "$INSTDIR\needle.png"
	Delete "$INSTDIR\m0d_s0beit_sa_setup.log"

	; this should not be deleted
	;Delete "$INSTDIR\m0d_s0beit_sa.ini"
	; or these
	;Delete "$INSTDIR\data\carmods.two"
	;Delete "$INSTDIR\data\default.two"
	;Delete "$INSTDIR\data\handling.two"
	;Delete "$INSTDIR\data\shopping.two"
	;Delete "$INSTDIR\data\timecyc.two"
	;Delete "$INSTDIR\data\vehicles.two"
	;Delete "$INSTDIR\data\surface.two"

	Delete "$INSTDIR\Uninstall_${NAME}.exe"
SectionEnd
