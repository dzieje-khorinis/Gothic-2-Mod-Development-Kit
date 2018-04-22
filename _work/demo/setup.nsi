;===============================================================================
;
;                         G2MDK - DemoMod Setup-Script
;
;                    System:  NSIS 2.0  http://nsis.sf.net/
;                    Editor:  HMNE 2.0  http://hmne.sf.net/
;
;===============================================================================



; Kompressionseinstellungen

CRCCheck force
;SetCompressor  lzma
;SetCompressorDictSize 128 ; LZMA-Speicherverbrauch, siehe Tabelle
; DictSize Compress Decomp
;    8 MB   141 MB   10 MB (default)
;   12 MB   179 MB   14 MB
;   16 MB   217 MB   18 MB
;   24 MB   293 MB   26 MB
;   32 MB   369 MB   35 MB
;   48 MB   521 MB   50 MB
;   64 MB   673 MB   66 MB
;   96 MB   977 MB   98 MB
;  128 MB  1281 MB  130 MB
;  192 MB  1889 MB  194 MB
;!packhdr "packhdr.tmp" "upx.exe --best packhdr.tmp" ; http://upx.sf.net/


; Definitionen

; TODO: Version der Modifikation
!define VER_MAJOR 1 ; Major Version
!define VER_MINOR 0 ; Minor Version
!define VER_PATCH 0 ; Patch-Version (1=a, ...)
!define VER_FLAGS 0 ; Sprachversion
!define VER_FILE  "${VER_MAJOR}.${VER_MINOR}"
!define VER_TEXT  "${VER_MAJOR}.${VER_MINOR}"

; TODO: Eigenschaften der Modifikation
!define MOD_FILE "demomod" ; Mod-Dateiname (KEINE Leer- oder Sonderzeichen!)
!define MOD_NAME "G2MDK - DemoMod"                 ; Mod-Titel
!define MOD_COPY "Copyright © 2004, Pluto 13 GmbH" ; Mod-Copyright
!define MOD_COMP "Piranha Bytes"                   ; Mod-Herausgeber
!define MOD_LINK "http://www.piranha-bytes.de"     ; Herausgeber-Link
!define MOD_HELP "http://www.gothic2.de/mod"       ; Support-Link


;===============================================================================
;
;   MUI
;


!include "MUI.nsh"


Name "${MOD_NAME} ${VER_TEXT}"
OutFile "${MOD_FILE}-${VER_FILE}.exe"
InstallDir "$PROGRAMFILES\JoWooD\Gothic II\"
!define MOD_RKEY "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${MOD_NAME}"
InstallDirRegKey HKLM "${MOD_RKEY}" "InstallLocation"
AllowRootDirInstall true


; Konfiguration (Installer)

!define MUI_WELCOMEPAGE_TITLE_3LINES
!define MUI_WELCOMEPAGE_TEXT "Dieser Assistent wird Sie durch die Installation von $(^Name) begleiten.\r\n\r\nEs wird empfohlen vor der Installation alle anderen Programme zu schließen.\r\n\r\n$_CLICK"
!define MUI_COMPONENTSPAGE_NODESC
!define MUI_FINISHPAGE_NOREBOOTSUPPORT
!define MUI_FINISHPAGE_TITLE_3LINES

; Setup-Seiten (Installer)

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE ".\setup\licence.rtf"
Page custom PageReinstall PageLeaveReinstall
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Konfiguration (Uninstaller)

!define MUI_WELCOMEPAGE_TITLE_3LINES
!define MUI_WELCOMEPAGE_TEXT "Dieser Assistent wird Sie durch die Deinstallation von $(^Name) begleiten.\r\n\r\nBitte beenden Sie Gothic II und zugehörige Tools,\r\nbevor Sie mit der Deinstallation fortfahren.\r\n\r\n$_CLICK"
!define MUI_FINISHPAGE_NOREBOOTSUPPORT
!define MUI_FINISHPAGE_TITLE_3LINES

; Setup-Seiten (Uninstaller)

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_COMPONENTS
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH


; Setup-Sprache

!insertmacro MUI_LANGUAGE "German"


; Reservierte Dateien

ReserveFile "setup.ini"
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS


;===============================================================================
;
;   Installer
;


; Setup.exe Versionsinformationen (Sprache = MUI_LANGUAGE)
VIProductVersion "${VER_MAJOR}.${VER_MINOR}.${VER_PATCH}.${VER_FLAGS}"
VIAddVersionKey "CompanyName"      "${MOD_COMP}"
VIAddVersionKey "FileVersion"      "${VER_TEXT}"
VIAddVersionKey "LegalCopyright"   "${MOD_COPY}"
VIAddVersionKey "FileDescription"  "${MOD_NAME}"
VIAddVersionKey "OriginalFilename" "${MOD_FILE}-${VER_FILE}.exe"


LangString NameInstFull ${LANG_GERMAN} "Vollständig"
InstType $(NameInstFull)


!include ".\setup\g2mod.nsh"


;-------------------------------------------------------------------------------
;
;   Init (nicht angezeigt)
;


; Installer

Section -pre
  Push $R0

  SetDetailsPrint none
  StrCpy $R0 "${MOD_RKEY}"

  ; Setup-Parameter in die Registrierung schreiben
  ClearErrors
  WriteRegExpandStr HKLM $R0 "InstallLocation" $INSTDIR
  IfErrors "" write
  MessageBox MB_OK|MB_ICONSTOP "Beim Schreiben der Werte für die spätere Deinstallation trat ein Fehler auf.$\r$\nStellen Sie sicher, dass Ihr Benutzerkonto über die notwendigen Rechte verfügt.$\r$\n$\r$\n(HKLM\$R0)"
  Pop $R0
  Abort
  write:
  WriteRegDWORD     HKLM $R0 "VersionMajor"    ${VER_MAJOR}
  WriteRegDWORD     HKLM $R0 "VersionMinor"    ${VER_MINOR}
  WriteRegDWORD     HKLM $R0 "VersionPatch"    ${VER_PATCH}
  WriteRegDWORD     HKLM $R0 "VersionFlags"    ${VER_FLAGS}
  WriteRegStr       HKLM $R0 "DisplayIcon"     "$INSTDIR\System\Gothic2.exe,0"
  WriteRegStr       HKLM $R0 "DisplayName"     "${MOD_NAME}"
  WriteRegStr       HKLM $R0 "DisplayVersion"  "${VER_TEXT}"
  WriteRegDWORD     HKLM $R0 "NoModify"        1
  WriteRegDWORD     HKLM $R0 "NoRepair"        1
  WriteRegExpandStr HKLM $R0 "UninstallString" "$INSTDIR\${MOD_FILE}-uninst.exe"
  WriteRegStr       HKLM $R0 "Publisher"       "${MOD_COMP}"
  WriteRegStr       HKLM $R0 "URLInfoAbout"    "${MOD_LINK}"
  WriteRegStr       HKLM $R0 "HelpLink"        "${MOD_HELP}"

  Pop $R0
SectionEnd


;-------------------------------------------------------------------------------
;
;   Modifikation
;


; Installer

LangString NameSecModFiles ${LANG_GERMAN} "${MOD_NAME}"
LangString TextSecModFiles ${LANG_GERMAN} "Installiere ${MOD_NAME}..."

Section !$(NameSecModFiles) SecModFiles

  SectionIn RO ; nicht abwählbar

  SetDetailsPrint textonly
  DetailPrint $(TextSecModFiles)
  SetDetailsPrint listonly

  SetOverwrite on

  ; Installiere Mod-Konfiguration
  SetOutPath "$INSTDIR\System"
  File      ".\install\System\${MOD_FILE}.ini"
  ; Installiere Mod-Volume
  SetOutPath "$INSTDIR\Data\modvdf"
  File      ".\install\Data\modvdf\${MOD_FILE}.mod"
  ; Eventuelles Mod-Volume in /Data entfernen
  !insertmacro g2mod_DeleteFile "$INSTDIR\Data\${MOD_FILE}.mod"
  
  ; Einträge im Startmenü
  SetShellVarContext current
  !insertmacro g2mod_CreateDirectory "$SMPROGRAMS\JoWooD\Gothic II\Modifikationen"
  CreateShortCut "$SMPROGRAMS\JoWooD\Gothic II\Modifikationen\${MOD_NAME}.lnk" \
    "$INSTDIR\System\GothicStarter.exe" "-game:${MOD_FILE}.ini"
  CreateShortCut "$SMPROGRAMS\JoWooD\Gothic II\Modifikationen\${MOD_NAME} entfernen.lnk" \
   	"$INSTDIR\${MOD_FILE}-uninst.exe"

SectionEnd


; Uninstaller

Section !un.$(NameSecModFiles) unSecModFiles

  SectionIn RO  ; nicht abwählbar

  ; Mod-Volume und Mod-Volume-Map entfernen
  !insertmacro g2mod_DeleteFile "$INSTDIR\vdfs_${MOD_FILE}.dmp"
  !insertmacro g2mod_DeleteFile "$INSTDIR\Data\${MOD_FILE}.mod"
  !insertmacro g2mod_DeleteFile "$INSTDIR\Data\modvdf\${MOD_FILE}.mod"
  ; /Data/modvdf wird nur entfernt, wenn es leer ist
  !insertmacro g2mod_RemoveDirectory "$INSTDIR\Data\modvdf"
  ; Mod-Konfiguration entfernen
  !insertmacro g2mod_DeleteFile "$INSTDIR\System\${MOD_FILE}.ini"
  
  ; Einträge im Startmenü entfernen
  SetShellVarContext current
  !insertmacro g2mod_DeleteFile "$SMPROGRAMS\JoWooD\Gothic II\Modifikationen\${MOD_NAME}.lnk"
  !insertmacro g2mod_DeleteFile "$SMPROGRAMS\JoWooD\Gothic II\Modifikationen\${MOD_NAME} entfernen.lnk"
  ; Werden nur entfernt, falls die Verzeihcnisse leer sind...
  !insertmacro g2mod_RemoveDirectory "$SMPROGRAMS\JoWooD\Gothic II\Modifikationen"
  !insertmacro g2mod_RemoveDirectory "$SMPROGRAMS\JoWooD\Gothic II"
  !insertmacro g2mod_RemoveDirectory "$SMPROGRAMS\JoWooD"

SectionEnd


;-------------------------------------------------------------------------------
;
;   Spielstände
;


LangString NameSecModSaves ${LANG_GERMAN} "Spielstände von ${MOD_NAME}"


; Installer (nicht angezeigt)

Section -$(NameSecModSaves) SecModSaves

  ; Mod-Savegame Verzeichnis anlegen
  !insertmacro g2mod_CreateDirectory "$INSTDIR\saves_${MOD_FILE}\current"

SectionEnd


; Uninstaller

Section un.$(NameSecModSaves) unSecModSaves

  ; Mod-Savegames entfernen
  RMDir /r "$INSTDIR\saves_${MOD_FILE}"

SectionEnd

;-------------------------------------------------------------------------------
;
;   Cleanup (nicht angezeigt)
;


; Installer

Section -post

  SetDetailsPrint none

  ; Uninstaller schreiben
  Delete           "$INSTDIR\${MOD_FILE}-uninst.exe"
  WriteUninstaller "$INSTDIR\${MOD_FILE}-uninst.exe"

SectionEnd


; Uninstaller

Section -un.post

  SetDetailsPrint none

  ; Registrierungsdaten entfernen
  DeleteRegKey HKLM "${MOD_RKEY}"

  ; Uninstaller entfernen
  Delete "$INSTDIR\${MOD_FILE}-uninst.exe"

SectionEnd


;===============================================================================
;
;   Player-Kit
;


Section -g2mpk
  SetOverwrite on
  SetDetailsPrint none
  SetShellVarContext current
  !insertmacro g2mod_InstallPlayerKit
SectionEnd


;===============================================================================
;
;   Callback-Funktionen
;


; Installer (Init)

Function .onInit
  Push $R0

  SetCurInstType 0

  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "setup.ini"

  ; Kein 'unsichtbares' Setup
  SetSilent normal
  
  ; $INSTDIR bereits gültig?
  IfFileExists "$INSTDIR\System\Gothic2.exe" done

  ; Sonst Add-ON Installation suchen (Registrierung)
  Call g2mod_GetInstallLocation
  Pop $R0
  StrCmp $R0 "" done
  ; Übernehmen
  StrCpy $INSTDIR $R0

  done:
  Pop $R0
FunctionEnd


; Uninstaller (Init)

Function un.onInit
  Push $R0

  ; $INSTDIR gültig?
  IfFileExists "$INSTDIR\System\Gothic2.exe" done

  ; Mod-Installation suchen (Registrierung)
  ReadRegStr $R0 HKLM "${MOD_RKEY}" "InstallLocation"
  StrCmp $R0 "" wrong
  StrCpy $INSTDIR $R0
  IfFileExists "$INSTDIR\System\Gothic2.exe" done
  ; Nicht gefunden...
  wrong:
  MessageBox MB_YESNO|MB_ICONQUESTION "Das Installationsverzeichnis scheint ungültig zu sein.$\r$\nSoll die Deinstallation trotzdem fortgesetzt werden?" IDYES done
    Pop $R0
    Abort

  done:
  Pop $R0
FunctionEnd


; Reinstall

LangString TextReinstTitle ${LANG_GERMAN} "Vorherige Installation"
LangString TextReinstHead1 ${LANG_GERMAN} "Wählen Sie aus, wie $(^Name) installiert werden soll."
LangString TextReinstOpt1A ${LANG_GERMAN} "Vorher deinstallieren"
LangString TextReinstOpt1B ${LANG_GERMAN} "Nicht deinstallieren"
LangString TextReinstHead2 ${LANG_GERMAN} "Wählen Sie die auszuführende Wartungsoption aus."
LangString TextReinstOpt2A ${LANG_GERMAN} "Erneut installieren"
LangString TextReinstOpt2B ${LANG_GERMAN} "$(^Name) deinstallieren"
LangString TextReinstWrong ${LANG_GERMAN} "Eine inkompatible Version ist bereits installiert!\r\nWenn Sie diese Version wirklich installieren wollen,\r\nsollten Sie die aktuelle Version vorher deinstallieren."
LangString TextReinstOlder ${LANG_GERMAN} "Eine ältere Version ist auf Ihrem System installiert.\r\nEs wird empfohlen die aktuelle Version vorher zu deinstallieren."
LangString TextReinstNewer ${LANG_GERMAN} "Eine neuere Version ist bereits auf Ihrem System installiert!\r\nEs wird empfohlen die ältere Version nicht zu installieren. Wenn Sie diese ältere Version wirklich installieren wollen, sollten Sie die aktuelle Version vorher deinstallieren."
LangString TextReinstEqual ${LANG_GERMAN} "$(^Name) ist bereits installiert."

Function PageReinstall

  ; Installationsverzeichnis lesen
  ReadRegStr $R0 HKLM "${MOD_RKEY}" "InstallLocation"
  StrCmp $R0 "" 0 +2
  Abort

  ; Version überprüfen
  ReadRegDWORD $R0 HKLM "${MOD_RKEY}" "VersionFlags"
  IntCmp $R0 ${VER_FLAGS} major wrong wrong
  major:
  ReadRegDWORD $R0 HKLM "${MOD_RKEY}" "VersionMajor"
  IntCmp $R0 ${VER_MAJOR} minor older newer
  minor:
  ReadRegDWORD $R0 HKLM "${MOD_RKEY}" "VersionMinor"
  IntCmp $R0 ${VER_MINOR} patch older newer
  patch:
  ReadRegDWORD $R0 HKLM "${MOD_RKEY}" "VersionPatch"
  IntCmp $R0 ${VER_PATCH} equal older newer
  wrong:
  !insertmacro MUI_INSTALLOPTIONS_WRITE "setup.ini" "Field 1" "Text" "$(TextReinstWrong)"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "setup.ini" "Field 2" "Text" "$(TextReinstOpt1A)"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "setup.ini" "Field 3" "Text" "$(TextReinstOpt1B)"
  !insertmacro MUI_HEADER_TEXT "$(TextReinstTitle)" "$(TextReinstHead1)"
  StrCpy $R0 "1"
  Goto start
  older:
  !insertmacro MUI_INSTALLOPTIONS_WRITE "setup.ini" "Field 1" "Text" "$(TextReinstOlder)"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "setup.ini" "Field 2" "Text" "$(TextReinstOpt1A)"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "setup.ini" "Field 3" "Text" "$(TextReinstOpt1B)"
  !insertmacro MUI_HEADER_TEXT "$(TextReinstTitle)" "$(TextReinstHead1)"
  StrCpy $R0 "1"
  Goto start
  newer:
  !insertmacro MUI_INSTALLOPTIONS_WRITE "setup.ini" "Field 1" "Text" "$(TextReinstNewer)"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "setup.ini" "Field 2" "Text" "$(TextReinstOpt1A)"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "setup.ini" "Field 3" "Text" "$(TextReinstOpt1B)"
  !insertmacro MUI_HEADER_TEXT "$(TextReinstTitle)" "$(TextReinstHead1)"
  StrCpy $R0 "1"
  Goto start
  equal:
  !insertmacro MUI_INSTALLOPTIONS_WRITE "setup.ini" "Field 1" "Text" "$(TextReinstEqual)"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "setup.ini" "Field 2" "Text" "$(TextReinstOpt2A)"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "setup.ini" "Field 3" "Text" "$(TextReinstOpt2B)"
  !insertmacro MUI_HEADER_TEXT "$(TextReinstTitle)" "$(TextReinstHead2)"
  StrCpy $R0 "2"
  start:
  !insertmacro MUI_INSTALLOPTIONS_DISPLAY "setup.ini"

FunctionEnd

Function PageLeaveReinstall

  !insertmacro MUI_INSTALLOPTIONS_READ $R1 "setup.ini" "Field 2" "State"
  StrCmp $R0 "1" 0 +2
  StrCmp $R1 "1" inst done
  StrCmp $R0 "2" 0 +3
  StrCmp $R1 "1" done inst
  inst:
  HideWindow
  ReadRegStr $R1 HKLM "${MOD_RKEY}" "UninstallString"
  ClearErrors
  ExecWait '$R1 _?=$INSTDIR'
  IfErrors nope
  IfFileExists $R1 "" nope
  Delete $R1
  nope:
  StrCmp $R0 "2" 0 +2
  Quit
  BringToFront

  done:
FunctionEnd


; Installer (Verzeichnisprüfung)

Var VerifyMessageOnce

Function .onVerifyInstDir

  ; Version 2.6 deutsch installiert ?
  !insertmacro g2mod_IfInstallVersion $INSTDIR "2.6.0.0" done
  ; Basisversion 2.6 ?
  !insertmacro g2mod_IfInstallVersionBase $INSTDIR "2.6" code
  Goto nope
  code:
  ; Deutsche Version ?
  !insertmacro g2mod_IfInstallVersionCode $INSTDIR 0 done

  ; Keine 2.6-er (deutsch)...
  nope:
  ; Meldung nur einmalig anzeigen
  StrCmp $VerifyMessageOnce "done" +3
  MessageBox MB_OK|MB_ICONINFORMATION "Wählen Sie das Verzeichnis aus, in welchem sich 'Gothic II - Die Nacht des Raben' 2.6 (deutsch) befindet."
  StrCpy $VerifyMessageOnce "done"
  Abort

  done:
FunctionEnd


