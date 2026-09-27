# Система мониторинга доступности api-сервиса и автоматизации анализа логов 

## Настройка безопасного ssh соединения с сервером
Сгенерируйте ssh ключ

`ssh-keygen -t ed25519 -C "your_email@example.com"`

Убедитесь в наличии нужных прав доступа к приватному ключу 

`chmod 600 ~/.ssh/id_ed25519`

Скопируйте публичный ключ на удаленный сервер

`ssh-copy-id user@server.example.com`

Убедитесь, что подключение по ssh ключу настроено и выполняется без пароля

`ssh user@server.example.com`

## Копирование репозитория на удаленный сервер распаковка
```
tar -czf - --exclude='.git' --exclude='*.log' --exclude='.github' --exclude='.gitignore' --exclude='README.md' . \
  | ssh user@server.example.com "mkdir -p /opt/infra-monitoring && tar -xzf - -C /opt/infra-monitoring"
```

## Запуск сервисов в контейнере на удаленном сервере
`ssh user@server.example.com "cd /opt/infra-monitoring && && docker compose up -d" `
