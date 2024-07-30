param (
    [string]$filePath,
    [string]$oldBaseName,
    [string]$newBaseName
)

# ファイル内容を行ごとに読み込み
$lines = Get-Content $filePath

# 2行目の内容をチェックして置き換え
if ($lines[1] -contains $oldBaseName) {
    $lines[1] = $lines[1] -replace $oldBaseName, $newBaseName
    Write-Output "Line 2 contains base name, replacing..."
} else {
    Write-Output "Line 2 does not contain base name."
}

# 変更後の内容を書き戻す
$lines | Set-Content $filePath
