@echo off
cls
title Resetar INTERNET
REM mode con:cols=70 lines=27
REM chcp 437 >nul
cls

:init
    setlocal EnableExtensions DisableDelayedExpansion
    set cmdInvoke=1
    set winSysFolder=System32
    set "batchPath=%~f0"
    for %%k in ("%~f0") do set batchName=%%~nk
    set "vbsGetPrivileges=%TEMP%\getPrivilegesFor%batchName%.vbs"
    setlocal EnableDelayedExpansion

:check_privileges
    %SystemRoot%\%winSysFolder%\whoami.exe /groups /nh | %SystemRoot%\%winSysFolder%\find.exe "S-1-16-12288" 1>nul
    if errorlevel 1 goto get_privileges

:check_privileges2
    %SystemRoot%\%winSysFolder%\net.exe session 1>nul 2>nul
    if not errorlevel 1 goto got_privileges

:get_privileges
    if "%~1"=="ELEV" (echo ELEV & shift /1 & goto got_privileges)
    echo Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
    echo args = "ELEV " >> "%vbsGetPrivileges%"
    echo For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
    echo args = args ^& strArg ^& " " >> "%vbsGetPrivileges%"
    echo Next >> "%vbsGetPrivileges%"

    if "%cmdInvoke%"=="1" goto invoke_cmd

    echo UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
    goto exec_elevation

:invoke_cmd
    echo args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
    echo UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:exec_elevation
    "%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
    exit /B

:got_privileges
    endlocal
    setlocal
    cd /d "%~dp0"
    if "%~1"=="ELEV" (del "%vbsGetPrivileges%" 1>nul 2>nul & shift /1)
    goto start

:start
    set "vbsMsg=%temp%\msg.vbs"
    echo res = msgbox("Este script limpa drivers de rede e wifi salvos. Deseja prosseguir?", 36, "Aviso do script") > "%vbsMsg%"
    echo wscript.quit res >> "%vbsMsg%"
    wscript.exe "%vbsMsg%"
    set "resposta=%errorlevel%"
    del "%vbsMsg%"

    if "%resposta%"=="6" goto main
    echo Operacao cancelada.
    timeout 3 >nul
    exit

:main
    echo Executando limpeza...
    netsh winsock reset
    netsh int ip reset
    netsh winhttp reset proxy 
    nbtstat -R
    nbtstat -RR
    ipconfig /release
    ipconfig /renew
    ipconfig /flushdns
    arp -d *
    netcfg -d
    pnputil /scan-devices

    echo Processo concluido!
    pause
