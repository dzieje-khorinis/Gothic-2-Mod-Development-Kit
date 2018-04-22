;===============================================================================
;
;               G2MOD (Gothic II - Modification) Setup Macros
;               Copyright (c) 2004 Nico Bendlin - Version 2.6
;
;                  System:   NSIS 2.0  http://nsis.sf.net/
;                  Editor:   HMNE 2.0  http://hmne.sf.net/
;
;===============================================================================


!ifndef G2MOD_NSH_INCLUDED
!define G2MOD_NSH_INCLUDED


;===============================================================================
;
;   Player-Kit
;


Function g2mod_InstallPlayerKitEx
  Exch $R0
  Push $R1
  Push $R2
  Push $R3
  Push $R4
  Push $R5
  Push $R6
  Push $R7
  Push $R8
  Push $R9
  GetDLLVersion "$R0\System\GothicStarter.exe" $R1 $R2
  IntOp $R3 $R1 / 0x00010000 ; major
  IntOp $R4 $R1 & 0x0000FFFF ; minor
  IntOp $R5 $R2 / 0x00010000 ; patch
  IntOp $R9 $R2 & 0x0000FFFF ; flags
  StrCpy $R9 "$R3.$R4.$R5.$R9"
  GetDLLVersionLocal ".\setup\GothicStarter.exe" $R1 $R2
  IntOp $R6 $R1 / 0x00010000 ; major
  IntOp $R7 $R1 & 0x0000FFFF ; minor
  IntOp $R8 $R2 / 0x00010000 ; patch
  IntCmp $R3 $R6 "" inst done
  IntCmp $R4 $R7 "" inst done
  IntCmp $R5 $R8 done "" done
  inst:
  IntOp $R9 $R2 & 0x0000FFFF ; flags
  StrCpy $R9 "$R6.$R7.$R8.$R9"
  StrCmp $OUTDIR "$R0\System" +2
  SetOutPath "$R0\System"
  File ".\setup\GothicGame.ini"
  File ".\setup\GothicStarter.exe"
  StrCpy $R1 "Gothic II - Die Nacht des Raben.lnk"
  StrCpy $R2 "System\GothicStarter.exe"
  IfFileExists "$DESKTOP\$R1" "" +3
  Delete "$DESKTOP\$R1"
  CreateShortCut "$DESKTOP\$R1" "$R0\$R2"
  StrCpy $R1 "JoWooD\Gothic II\$R1"
  IfFileExists "$SMPROGRAMS\$R1" "" +3
  Delete "$SMPROGRAMS\$R1"
  CreateShortCut "$SMPROGRAMS\$R1" "$R0\$R2"
  done:
  StrCpy $R0 $R9
  Pop $R9
  Pop $R8
  Pop $R7
  Pop $R6
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Pop $R1
  Exch $R0
FunctionEnd


!macro g2mod_InstallPlayerKit
  SetOverwrite on
  SetDetailsPrint none
  Push $R0
  Push $INSTDIR
  Call g2mod_InstallPlayerKitEx
  Pop $R0 ; installed version (string)
  Pop $R0
  SetDetailsPrint lastused
  SetOverwrite lastused
!macroend


;===============================================================================
;
;   Install
;


Function g2mod_GetInstallLocation
  Push $R0
  Push $R1
  Push $R2
  StrCpy $R1 "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Gothic II - Die Nacht des Raben"
  ReadRegStr $R0 HKLM $R1 "InstallLocation"
  StrCmp $R0 "" "" done
  ReadRegStr $R0 HKLM $R1 "UninstallString"
  StrCmp $R0 "" done
  Push $R0
  Push "\UNWISE.EXE"
  Call g2mod_StrStr
  Pop $R1
  StrCmp $R1 "" "" +2
  StrCpy $R1 $R0
  StrLen $R2 $R1
  StrLen $R1 $R0
  IntOp $R1 $R1 - $R2
  StrCpy $R0 $R0 $R1
  GetFullPathName $R0 $R0
  done:
  Pop $R2
  Pop $R1
  Exch $R0
FunctionEnd


Function g2mod_GetInstallVersion
  Exch $R0
  Push $R1
  Push $R2
  Push $R3
  Push $R4
  Push $R5
  GetDLLVersion "$R0\System\Gothic2.exe" $R0 $R1
  IntOp $R2 $R0 / 0x00010000
  IntOp $R3 $R0 & 0x0000FFFF
  IntOp $R4 $R1 / 0x00010000
  IntOp $R5 $R1 & 0x0000FFFF
  StrCpy $R0 "$R2.$R3.$R4.$R5"
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Pop $R1
  Exch $R0
FunctionEnd

!macro g2mod_IfInstallVersion ROOT VERS JUMP
  Push $R0
  Push "${ROOT}"
  Call g2mod_GetInstallVersion
  Pop $R0
  StrCmp $R0 "${VERS}" +3
  Pop $R0
  Goto +3
  Pop $R0
  Goto "${JUMP}"
!macroend


Function g2mod_GetInstallVersionBase
  Exch $R0
  Push $R1
  Push $R2
  Push $R3
  GetDLLVersion "$R0\System\Gothic2.exe" $R0 $R1
  IntOp $R2 $R0 / 0x00010000
  IntOp $R3 $R0 & 0x0000FFFF
  StrCpy $R0 "$R2.$R3"
  Pop $R3
  Pop $R2
  Pop $R1
  Exch $R0
FunctionEnd

!macro g2mod_IfInstallVersionBase ROOT BASE JUMP
  Push $R0
  Push "${ROOT}"
  Call g2mod_GetInstallVersionBase
  Pop $R0
  StrCmp $R0 "${BASE}" +3
  Pop $R0
  Goto +3
  Pop $R0
  Goto "${JUMP}"
!macroend


Function g2mod_GetInstallVersionCode
  Exch $R0
  Push $R1
  Push $R2
  Push $R3
  ClearErrors
  GetDLLVersion "$R0\System\Gothic2.exe" $R0 $R1
  IntOp $R0 0 - 1
  IfErrors done
  IntOp $R0 $R1 & 0x0000FFFF
  done:
  Pop $R3
  Pop $R2
  Pop $R1
  Exch $R0
FunctionEnd

!macro g2mod_IfInstallVersionCode ROOT CODE JUMP
  Push $R0
  Push "${ROOT}"
  Call g2mod_GetInstallVersionCode
  Pop $R0
  IntCmp $R0 ${CODE} +3
  Pop $R0
  Goto +3
  Pop $R0
  Goto "${JUMP}"
!macroend


!macro g2mod_SetOutPath FILEPATH
  StrCmp "$OUTDIR" "${FILEPATH}" +2
  SetOutPath "${FILEPATH}"
!macroend


;===============================================================================
;
;   Directories
;


!macro g2mod_CreateDirectory FILEPATH
  IfFileExists "${FILEPATH}" +2
  CreateDirectory "${FILEPATH}"
!macroend


!macro g2mod_RemoveDirectory FILEPATH
  IfFileExists "${FILEPATH}\*.*" "" +2
  RMDir "${FILEPATH}"
!macroend


;===============================================================================
;
;   Files
;


!macro g2mod_DeleteFile FILENAME
  IfFileExists "${FILENAME}" "" +2
  Delete "${FILENAME}"
!macroend


!macro g2mod_BackupFile FILENAME
  IfFileExists "${FILENAME}" "" +4
  IfFileExists "${FILENAME}.bak" "" +2
  Delete "${FILENAME}.bak"
  Rename "${FILENAME}" "${FILENAME}.bak"
!macroend


!macro g2mod_RestoreFile FILENAME
  IfFileExists "${FILENAME}.bak" "" +4
  IfFileExists "${FILENAME}" "" +2
  Delete "${FILENAME}"
  Rename "${FILENAME}.bak" "${FILENAME}"
!macroend


!macro g2mod_SetFilename FILENAME
  IfFileExists "${FILENAME}" "" +2
  Rename "${FILENAME}" "${FILENAME}"
!macroend


;===============================================================================
;
;   Volumes
;


!macro g2mod_DisableVolume FILENAME
  IfFileExists "${FILENAME}" "" +4
  IfFileExists "${FILENAME}.disabled" "" +2
  Delete "${FILENAME}.disabled"
  Rename "${FILENAME}" "${FILENAME}.disabled"
!macroend


!macro g2mod_EnableVolume FILENAME
  IfFileExists "${FILENAME}.disabled" "" +4
  IfFileExists "${FILENAME}" "" +2
  Delete "${FILENAME}"
  Rename "${FILENAME}.disabled" "${FILENAME}"
!macroend


!macro g2mod_ExtractVolumeEx FILENAME ROOT
  !insertmacro g2mod_SetOutPath "${ROOT}"
  IfFileExists "${FILENAME}" "" +3
  ExecWait '"${ROOT}\_work\tools\VDFS\GothicVDFS.exe" /X "${FILENAME}"'
  Goto +3
  IfFileExists "${FILENAME}.disabled" "" +2
  ExecWait '"${ROOT}\_work\tools\VDFS\GothicVDFS.exe" /X "${FILENAME}.disabled"'
!macroend


!macro g2mod_ExtractVolume FILENAME
  !insertmacro g2mod_ExtractVolumeEx "${FILENAME}" $INSTDIR
!macroend


!macro g2mod_ExtractAndDisableVolume FILENAME
  !insertmacro g2mod_ExtractVolume "${FILENAME}"
  !insertmacro g2mod_DisableVolume "${FILENAME}"
!macroend


;===============================================================================
;
;   Utilities
;


Function g2mod_StrStr
  Exch $R1
  Exch
  Exch $R2
  Push $R3
  Push $R4
  Push $R5
  StrLen $R3 $R1
  StrCpy $R4 0
  loop:
  StrCpy $R5 $R2 $R3 $R4
  StrCmp $R5 $R1 done
  StrCmp $R5 "" done
  IntOp $R4 $R4 + 1
  Goto loop
  done:
  StrCpy $R1 $R2 "" $R4
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Exch $R1
FunctionEnd


;===============================================================================


!endif ;G2MOD_NSH_INCLUDED

