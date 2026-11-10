# .env.op に列挙したキーを Keychain から読み込む。Keychain への登録は sync-secrets で行う。
# Cursor は起動時にログインシェルの環境変数を読むので、direnv ではなくここで読み込む。

() {
  local env_file="$HOME/.config/secrets/.env.op" key ref val
  [[ -f "$env_file" ]] || return 0
  while IFS='=' read -r key ref; do
    [[ -z "$key" || "$key" == \#* ]] && continue
    val=$(/usr/bin/security find-generic-password -a "$USER" -s "$key" -w 2>/dev/null) && export "$key=$val"
  done < "$env_file"
}
