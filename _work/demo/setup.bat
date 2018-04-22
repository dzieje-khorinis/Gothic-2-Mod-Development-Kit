@echo off
attrib -R -S -H -A .\install /S /D

start /D.\ ..\tools\VDFS\GothicVDFS.exe .\setup.vm
exit
