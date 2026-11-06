@echo off
title WinDock Windows Server
cd /d "%~dp0"
echo ========================================================
echo        Starting WinDock Server for iPhone
echo ========================================================
py server.py || python server.py
pause
