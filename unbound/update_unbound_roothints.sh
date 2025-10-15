#!/bin/bash
# Скрипт обновления root.hints для Unbound

# Путь к файлу root.hints (проверь в своём unbound.conf)
ROOT_HINTS="/var/lib/unbound/root.hints"

echo "Скачиваю свежий root.hints..."
curl -s https://www.internic.net/domain/named.root -o "$ROOT_HINTS"

# Устанавливаем владельца (если unbound работает от пользователя unbound)
chown unbound:unbound "$ROOT_HINTS"

# Проверяем конфигурацию
echo "Проверка конфигурации..."
if unbound-checkconf; then
    echo "Конфигурация корректна ✅"
    systemctl restart unbound
    echo "Unbound перезапущен."
else
    echo "Ошибка в конфигурации ❌ — перезапуск отменён."
    exit 1
fi
