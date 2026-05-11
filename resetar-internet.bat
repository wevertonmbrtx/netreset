@echo off
setlocal

echo ========================================
echo   Reset de conexão de internet (Windows)
echo ========================================

echo.
echo [1/5] Limpando cache de DNS...
ipconfig /flushdns

echo.
echo [2/5] Liberando IP atual...
ipconfig /release

echo.
echo [3/5] Renovando IP...
ipconfig /renew

echo.
echo [4/5] Resetando Winsock...
netsh winsock reset

echo.
echo [5/5] Resetando pilha TCP/IP...
netsh int ip reset

echo.
echo Processo concluído.
echo Reinicie o computador para aplicar todas as alterações.
pause
