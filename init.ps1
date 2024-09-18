# シンボリックリンクを作成するための関数
function Create-Symlink {
    param (
        [string]$target,
        [string]$link
    )

    $targetFullPath = (Get-Item $target).FullName

    # 既存のリンクがあれば削除
    if (Test-Path $link) {
        Remove-Item $link -Force
        Write-Host "既存のシンボリックリンクを削除しました: $link"
    }

    # 新たにシンボリックリンクを作成
    New-Item -ItemType SymbolicLink -Path $link -Target $targetFullPath
    Write-Host "新しいシンボリックリンクを作成しました: $link -> $targetFullPath"
}

winget import -i winget.json

# シンボリックリンクを作成
Create-Symlink -target ".config\nvim" -link "$env:USERPROFILE\AppData\Local\nvim"
