#!/bin/bash
# Обновление blocklist.conf для Unbound
# Все источники, уникальность, проверка конфигурации

BLOCKLIST_FILE="/etc/unbound/blocklist.conf"
TMP_FILE=$(mktemp)

SOURCES=(
  "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.plus.txt"
  "https://blocklistproject.github.io/Lists/ads.txt"
  "https://blocklistproject.github.io/Lists/phishing.txt"
  "https://blocklistproject.github.io/Lists/fraud.txt"
  "https://blocklistproject.github.io/Lists/malware.txt"
  "https://v.firebog.net/hosts/AdguardDNS.txt"
  "https://v.firebog.net/hosts/Admiral.txt"
  "https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt"
  "https://v.firebog.net/hosts/Easylist.txt"
  "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext"
  "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts"
  "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts"
  "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts"
)

echo "Обновление blocklist.conf..."

for url in "${SOURCES[@]}"; do
  curl -s "$url" | awk '/^[0-9]/{print $2}' | sed 's/^www\.//' >> "$TMP_FILE"
done

sort -u -S 50% --parallel=1 "$TMP_FILE" > "${TMP_FILE}.uniq"

echo "# Автоматически сгенерированный blocklist" > "$BLOCKLIST_FILE"
while read -r domain; do
  [[ -n "$domain" ]] && echo "local-zone: \"$domain\" always_refuse" >> "$BLOCKLIST_FILE"
done < "${TMP_FILE}.uniq"

rm "$TMP_FILE" "${TMP_FILE}.uniq"

echo "Проверка конфигурации..."
if unbound-checkconf; then
    echo "Конфигурация корректна ✅"
    systemctl restart unbound
    echo "Unbound перезапущен."
else
    echo "Ошибка в конфигурации ❌ — перезапуск отменён."
    exit 1
fi
