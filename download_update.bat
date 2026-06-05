@echo off
setlocal

rem ========================================
rem Alice2333 Menu 自动下载更新脚本
rem 下载链接：https://antfcc0.1007890.xyz/download_alicemenu
rem ========================================

rem 配置项
set "URL=https://antfcc0.1007890.xyz/download_alicemenu"
set "OUT_ZIP=%~dp0alicemenu_latest.zip"
set "EXTRACT_DIR=%~dp0alicemenu"

echo ========================================
echo Alice2333 Menu 自动下载更新工具
echo ========================================
echo.

rem 检查是否已存在同名 zip，先删除以保证覆盖
if exist "%OUT_ZIP%" (
    echo [1/5] 删除已存在的 ZIP 文件...
    del /f /q "%OUT_ZIP%"
    echo       已删除：%OUT_ZIP%
) else (
    echo [1/5] 准备下载最新菜单文件
)
echo.

rem 下载文件
echo [2/5] 正在下载最新菜单文件...
echo       下载链接：%URL%
echo       保存位置：%OUT_ZIP%
echo.

powershell -NoProfile -Command ^
    "try { " ^
    "$ProgressPreference = 'SilentlyContinue'; " ^
    "$wc = New-Object System.Net.WebClient; " ^
    "$wc.DownloadFile('%URL%','%OUT_ZIP%'); " ^
    "Write-Host '下载成功！' -ForegroundColor Green; " ^
    "exit 0 " ^
    "} catch { " ^
    "Write-Host '下载失败：' $_.Exception.Message -ForegroundColor Red; " ^
    "exit 1 " ^
    "}"

if errorlevel 1 (
    echo.
    echo [错误] 下载失败，请检查：
    echo       1. 网络连接是否正常
    echo       2. 下载链接是否可访问
    echo       3. 是否有足够的磁盘空间
    echo.
    pause
    exit /b 1
)

echo.

rem 检查 ZIP 文件是否下载成功
if not exist "%OUT_ZIP%" (
    echo [错误] ZIP 文件不存在，下载可能失败
    pause
    exit /b 1
)

echo [3/5] ZIP 文件下载成功：%OUT_ZIP%
echo.

rem 如果已存在解压目录，先删除以实现覆盖
if exist "%EXTRACT_DIR%" (
    echo [4/5] 删除旧版本的解压目录...
    rmdir /s /q "%EXTRACT_DIR%"
    echo       已删除：%EXTRACT_DIR%
) else (
    echo [4/5] 准备解压到新目录
)
echo.

rem 创建解压目录
mkdir "%EXTRACT_DIR%"

rem 使用 PowerShell 解压
echo [5/5] 正在解压文件...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try { " ^
    "Add-Type -AssemblyName System.IO.Compression.FileSystem; " ^
    "[System.IO.Compression.ZipFile]::ExtractToDirectory('%OUT_ZIP%','%EXTRACT_DIR%'); " ^
    "Write-Host '解压完成！' -ForegroundColor Green; " ^
    "exit 0 " ^
    "} catch { " ^
    "Write-Host '解压失败：' $_.Exception.Message -ForegroundColor Red; " ^
    "exit 1 " ^
    "}"

if errorlevel 1 (
    echo.
    echo [错误] 解压失败，请检查：
    echo       1. ZIP 文件是否完整
    echo       2. 是否有足够的磁盘空间
    echo       3. 是否有目标目录的写入权限
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo ✅ 完成！
echo ========================================
echo.
echo 下载位置：%OUT_ZIP%
echo 解压位置：%EXTRACT_DIR%
echo.
echo 提示：下次运行此脚本将自动覆盖更新
echo.
pause

endlocal
exit /b 0
