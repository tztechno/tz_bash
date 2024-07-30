@echo off
setlocal enabledelayedexpansion

REM ファイルが存在するディレクトリを指定
set "directory=.\data"

echo "Starting batch script..."

REM ディレクトリ内の全ファイルを処理
for %%f in ("%directory%\*") do (
    REM ファイル名を取得（拡張子を含む）
    set "filename=%%~nxf"
    echo "Processing file: !filename!"
    
    REM 拡張子を除いたファイル名を取得
    set "base_name=%%~nf"
    echo "Base name: !base_name!"
    
    REM 拡張子の取得
    set "extension=%%~xf"
    echo "Extension: !extension!"
    
    REM ファイル名が6文字で、最初の2文字が'O0'であることを確認
    if "!base_name:~0,2!" == "O0" (
        set "name_length=0"
        for /L %%i in (0,1,5) do if "!base_name:~%%i,1!" neq "" set /a name_length+=1
        if "!name_length!" == "6" (
            REM 新しいファイル名を作成（先頭の'O0'を削除）
            set "new_base_name=O!base_name:~2!"
            echo "New base name: !new_base_name!"
            
            REM 新しいファイル名に拡張子を追加
            set "new_filename=!new_base_name!!extension!"
            echo "New filename: !new_filename!"
            
            REM ファイル名の変更
            echo "Renaming !filename! to !new_filename!"
            ren "%directory%\!filename!" "!new_filename!"
            
            REM PowerShellスクリプトを呼び出して2行目を置き換える
            echo "Checking and replacing line 2 if necessary..."
            for /f "tokens=*" %%A in ('powershell -ExecutionPolicy Bypass -File replace_line2.ps1 "%directory%\!new_filename!" "!base_name!" "!new_base_name!"') do (
                echo %%A
            )
            
            echo "Line 2 check and replace completed."
        ) else (
            echo "File does not match criteria (not 6 characters long)."
        )
    ) else (
        echo "File does not match criteria (does not start with O0)."
    )
)

echo "Batch script finished."

endlocal

