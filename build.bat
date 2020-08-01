@echo off
setlocal enabledelayedexpansion
title GSI打包工具 By ChasonJiang
echo.*******************************************
echo.
echo.            欢迎使用GSI打包工具
echo.
echo.              By ChasonJiang
echo.
echo.  注意事项:
echo.
echo.    1.请确认是否在python3环境使用
echo.
echo.    2.请确认gsi镜像已更名为gsi.img
echo.
echo.    3.请确认rom包及gsi镜像已放入input文件夹
echo.
echo.*******************************************
pause
rd /s /q output\ >nul 2>nul
md output\ >nul 2>nul
echo 正在解压rom包...
bin\7z.exe x "input\*.zip" -o"input\rom" >nul 2>nul 
if not exist "input\rom\*.br" (
echo 解压失败！
rd /s /q input\rom >nul 2>nul
ping 127.1 -n 5 >nul
exit
)

del /s input\rom\system.* >nul 2>nul
if exist "input\rom\compatibility.zip" del /s input\rom\compatibility.zip >nul 2>nul

cls
echo 正在转换gsi...
bin\simg2img.exe input\gsi.img input\rom\system.img >nul 2>nul
dir /a /s system.img >size.txt
bin\sed.exe -n '/system.img/p' size.txt >size1.txt
for /f "tokens=3" %%i in (size1.txt) do echo %%i>size.txt
del /s size1.txt >nul 2>nul
bin\sed.exe -i 's/,//g' size.txt
python bin\img2sdat.py -o input\rom\ -v 4 -p system input\gsi.img >nul 2>nul
move system.* input\rom >nul 2>nul
bin\brotli.exe -q 1 input\rom\system.new.dat >nul 2>nul
del /s input\rom\system.new.dat >nul 2>nul
del /s input\rom\system.img >nul 2>nul

cls
echo 正在修改动态分区文件...
bin\sed.exe -n '/resize\ssystem/p' input\rom\dynamic_partitions_op_list >temp.txt
set /p tmp=<temp.txt
set /p s=<size.txt
bin\sed.exe -i "s/!tmp!/resize system !s!/g" input\rom\dynamic_partitions_op_list
del /s size.txt >nul 2>nul
del /s temp.txt >nul 2>nul
ping 127.1 -n 3 >nul

cls
echo 正在生成rom包...
if exist "input\rom\firmware-update" (
bin\winrar.exe a -ep1 -o+ -inul -ibck "output\gsi_rom.zip" input\rom\* input\rom\META-INF input\rom\firmware-update
)
if exist not "input\rom\firmware-update" (
bin\winrar.exe a -ep1 -o+ -inul -ibck "output\gsi_rom.zip" input\rom\* input\rom\META-INF
)
rd /s /q input\rom >nul 2>nul

echo 完成！快去output查看吧！
pause