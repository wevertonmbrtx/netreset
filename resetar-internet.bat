@echo off
setlocal

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Este script precisa ser executado como administrador.
    echo Clique com o botão direito no arquivo e selecione "Executar como administrador".
    pause
    exit /b 1
)

set HAS_ERROR=0

echo ========================================
echo   Reset de conexão de internet (Windows)
echo ========================================

echo.
echo [1/5] Limpando cache de DNS...
ipconfig /flushdns
if errorlevel 1 (
    echo [ERRO] Falha ao limpar cache de DNS.
    set HAS_ERROR=1
) else (
    echo [OK] Cache de DNS limpo.
)

echo.
echo [2/5] Liberando IP atual...
ipconfig /release
if errorlevel 1 (
    echo [ERRO] Falha ao liberar IP atual.
    set HAS_ERROR=1
) else (
    echo [OK] IP atual liberado.
)

echo.
echo [3/5] Renovando IP...
ipconfig /renew
if errorlevel 1 (
    echo [ERRO] Falha ao renovar IP.
    set HAS_ERROR=1
) else (
    echo [OK] IP renovado.
)

echo.
echo [4/5] Resetando Winsock...
netsh winsock reset
if errorlevel 1 (
    echo [ERRO] Falha ao resetar Winsock.
    set HAS_ERROR=1
) else (
    echo [OK] Winsock resetado.
)

echo.
echo [5/5] Resetando pilha TCP/IP...
netsh int ip reset
if errorlevel 1 (
    echo [ERRO] Falha ao resetar pilha TCP/IP.
    set HAS_ERROR=1
) else (
    echo [OK] Pilha TCP/IP resetada.
)

echo.
if %HAS_ERROR% neq 0 (
    echo Processo concluído com erros. Verifique as mensagens acima.
) else (
    echo Processo concluído com sucesso.
)
echo Reinicie o computador para aplicar todas as alterações.
pause
