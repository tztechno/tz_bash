@echo off
setlocal enabledelayedexpansion

REM ファイルが存在するディレクトリを指定
set "directory=.\data"

REM ディレクトリ内の全ファイルを処理
for %%f in ("%directory%\*") do (
    REM ファイル名を取得（拡張子を含む）
    set "filename=%%~nxf"
    REM 拡張子を除いたファイル名を取得
    set "base_name=%%~nf"
    REM 拡張子の取得
    set "extension=%%~xf"
    REM 拡張子が空でない場合、ファイル名にドットを追加
    if not "!extension!" == "" (
        set "base_name=%%~nf"
    ) else (
        set "base_name=%%~nx"
    )
    REM ファイル名が6文字で、最初の2文字が'O0'であることを確認
    if "!base_name:~0,2!" == "O0" if "!base_name:~6,1!" == "" (
        REM 新しいファイル名を作成（先頭の'O0'を削除）
        set "new_base_name=O!base_name:~2!"
        REM 新しいファイル名に拡張子を追加
        set "new_filename=!new_base_name!!extension!"
        REM ファイル名の変更
        ren "%%f" "!new_filename!"
        REM 2行目をチェックし、変更前ファイル名が含まれていれば置き換える
        set "tempfile=%directory%\tempfile"
        (
            for /f "tokens=1,* delims=]" %%a in ('type "%directory%\!new_filename!"') do (
                if "%%b" == "!base_name!" (
                    echo %%a!new_base_name!
                ) else (
                    echo %%a%%b
                )
            )
        ) > "!tempfile!"
        REM 一時ファイルを元のファイルに戻す
        move /y "!tempfile!" "%directory%\!new_filename!"
    )
)

endlocal
