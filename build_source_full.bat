
@echo off
setlocal enabledelayedexpansion
title GSI������� By ChasonJiang
if not exist "input" md input >nul 2>nul
del /s readme.txt >nul 2>nul
echo.*******************************************>>readme.txt
echo.>>readme.txt
echo.            ��ӭʹ��GSI�������>>readme.txt
echo.>>readme.txt
echo.              By ChasonJiang>>readme.txt
echo.>>readme.txt
echo.  ע������:>>readme.txt
echo.>>readme.txt
echo.    1.��ȷ���Ƿ���python3����ʹ��>>readme.txt
echo.>>readme.txt
echo.    2.��ȷ��gsi�����Ѹ���Ϊgsi.img>>readme.txt
echo.>>readme.txt
echo.    3.��ȷ�ϵװ�/gsi�����ѷŽ�input�ļ���>>readme.txt
echo.>>readme.txt
echo.*******************************************>>readme.txt
echo.***************************************
echo.
echo.            ��ӭʹ��GSI�������
echo.
echo.              By ChasonJiang
echo.
echo.  ��ѡ������ʽ:
echo.
echo.       1.GSIֱ�Ӵ��
echo.
echo.       2.GSI�ӵװ����
echo.
echo.***************************************
set /p num=��ѡ��:
if !num!==1 (
goto not_decompression
)
if !num!==2 (
goto decompression
)
exit
:not_decompression
cls
if not exist "input\gsi.img" goto err1
bin\file_for_windows\file.exe .\input\gsi.img >info.txt
.\bin\sed.exe -i 's/Android/1/g' info.txt
.\bin\sed.exe -i 's/Linux/2/g' info.txt
if not exist "info.txt" goto err3
for /f "tokens=2" %%i in (info.txt) do set inf=%%i
del info.txt >nul 2>nul

rd /s /q output\ >nul 2>nul
md output\ >nul 2>nul
rd /s /q input\rom >nul 2>nul
md input\rom\META-INF\com\google\android\ >nul 2>nul

copy "need_files\updater-script" "input\rom\META-INF\com\google\android\" >nul 2>nul
copy "need_files\update-binary" "input\rom\META-INF\com\google\android\" >nul 2>nul
copy need_files\dynamic_partitions_op_list input\rom\ >nul 2>nul
if !inf!==1 goto trans
if !inf!==2 goto no_trans
goto err5
:decompression
cls
if not exist "input\gsi.img" goto err1
if not exist "input\*.zip" goto err2
bin\file_for_windows\file.exe .\input\gsi.img >info.txt
.\bin\sed.exe -i 's/Android/1/g' info.txt
.\bin\sed.exe -i 's/Linux/2/g' info.txt
if not exist "info.txt" goto err3
for /f "tokens=2" %%i in (info.txt) do set inf=%%i
del info.txt >nul 2>nul
rd /s /q input\rom >nul 2>nul

echo ���ڽ�ѹrom��...
bin\7z.exe x "input\*.zip" -o"input\rom" >nul 2>nul
if not exist "input\rom\*.br" (
echo ��ѹʧ�ܣ�
rd /s /q input\rom >nul 2>nul
ping 127.1 -n 5 >nul
exit
)
del /s input\rom\system.* >nul 2>nul
if exist "input\rom\compatibility.zip" del /s input\rom\compatibility.zip >nul 2>nul
if !inf!==1 goto trans
if !inf!==2 goto no_trans
goto err5
:trans
cls
echo ����ת��gsi...
bin\simg2img.exe input\gsi.img input\system.img >nul 2>nul
dir /a /s system.img >size.txt
bin\sed.exe -n '/system.img/p' size.txt >size1.txt
for /f "tokens=3" %%i in (size1.txt) do echo %%i>size.txt
del /s size1.txt >nul 2>nul
bin\sed.exe -i 's/,//g' size.txt
python\python.exe bin\img2sdat.py -o input\rom\ -v 4 -p system input\gsi.img >nul 2>nul
if not exist "input\rom\system.new.dat" goto err4
bin\brotli.exe -q 1 input\rom\system.new.dat  >nul 2>nul
if not exist "input\rom\system.new.dat.br" goto err4
del /s input\rom\system.new.dat >nul 2>nul
del /s input\system.img >nul 2>nul
goto patch
:no_trans
cls
echo. ��GSI������raw img,�ݲ���֧�֣�
pause
exit
echo ����ת��gsi...
dir /a /s gsi.img >size.txt
bin\sed.exe -n '/gsi.img/p' size.txt >size1.txt
for /f "tokens=3" %%i in (size1.txt) do echo %%i>size.txt
del /s size1.txt >nul 2>nul
bin\sed.exe -i 's/,//g' size.txt
python\python.exe bin\img2sdat.py -o input\rom\ -v 4 -p system input\gsi.img
bin\brotli.exe -q 1 input\rom\system.new.dat >nul 2>nul
del /s input\rom\system.new.dat >nul 2>nul
move input\rom\system.img input\gsi.img >nul 2>nul
pause
goto patch
:patch
cls
echo �����޸Ķ�̬�����ļ�...
bin\sed.exe -n '/resize\ssystem/p' input\rom\dynamic_partitions_op_list >temp.txt
set /p tmp=<temp.txt
set /p s=<size.txt
bin\sed.exe -i "s/!tmp!/resize system !s!/g" input\rom\dynamic_partitions_op_list
del /s size.txt >nul 2>nul
del /s temp.txt >nul 2>nul
ping 127.1 -n 3 >nul
goto repack
:repack
cls
rd /s /q output\ >nul 2>nul
if exist "output\gsi_rom.zip" (
echo.
echo.�޷�ɾ���ɵ�gsi_rom.zip!
echo.
echo.���ֶ�ɾ��,��������������
pause >nul 2>nul
)
md output\ >nul 2>nul
echo ��������rom��...
echo.
echo. ʱ����ܽϳ��������ĵȴ�...
if %num%==1 (
bin\winrar.exe a -ep1 -o+ -inul -ibck "output\gsi_rom.zip" input\rom\META-INF input\rom\*
)
if %num%==2 (
if exist "input\rom\firmware-update" (
bin\winrar.exe a -ep1 -o+ -inul -ibck "output\gsi_rom.zip" input\rom\META-INF input\rom\firmware-update input\rom\* 
)
if exist not "input\rom\firmware-update" (
bin\winrar.exe a -ep1 -o+ -inul -ibck "output\gsi_rom.zip" input\rom\META-INF input\rom\*
)
)
echo.
echo ��ɣ���ȥoutput�鿴�ɣ�
echo.
pause
exit
:err1
cls
echo.
echo. δ��⵽gsi.img,���飡
echo.
pause
exit
:err2
cls
echo.
echo. δ��⵽�װ�,���飡
echo.
pause
exit

:err3
cls
echo.
echo. ����ȱʧ,�뻷�����ã�
echo.
pause
exit

:err4
cls
echo.
echo.ת��ʧ�ܣ�
echo.
pause
exit

:err5
cls
echo.
echo.δ��֧�ֵ�img����
echo.
pause
exit

:jiaobenxiugai
chcp 65001 >nul 2>nul
echo ui_print("******************************");>script.txt
echo ui_print(" ");>>script.txt
echo ui_print("  Made by GSI packer tools  ");>>script.txt
echo ui_print(" ");>>script.txt
echo ui_print("  Date:%date% ");>>script.txt
echo ui_print(" ");>>script.txt
echo ui_print("  ROM Author:%author% ");>>script.txt
echo ui_print(" ");>>script.txt
echo ui_print("******************************");>>script.txt
move input\rom\META-INF\com\google\android\updater-script script1 >nul 2>nul
type script.txt script1 >updater-script 2>nul
move updater-script input\rom\META-INF\com\google\android\ >nul 2>nul
del /s script.txt >nul 2>nul
del /s script1 >nul 2>nul
chcp 936 >nul 2>nul
