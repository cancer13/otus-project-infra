# how2run
Инфраструктура разворачивается на мощностях [yandex cloud](https://cloud.yandex.ru).

[Установить yc cli](https://cloud.yandex.ru/docs/cli/operations/install-cli).

Выполнить `infra/terraform/yc_sa_create.sh`, генерирует SA для терраформа, путь до полученного ключа после вносится в terraform.tfvars

Создать в репозитории инфраструктуры файл `infra/terraform/terraform.tfvars` - файл добавлен в .gitignore

Добавить конфигурацию вида:
```
cloud_id         = "ВАШ_КЛАУД_АЙДИ"
folder_id        = "ВАШ_ФОЛДЕР_АЙДИ"
zone             = "ru-central1-a" # Зона в облаке
public_key_path  = "~/.ssh/id_rsa.pub" # путь к ключу для подключения к хостам
region_id = "ru-central1" # Регион в облаке
service_account_key_file = "/PATH/TO/key.json" # путь к ключу для сервисного аккаунта с ролью edit
network_id                = "ID_СЕТИ"
runner_registration_token = "ТОКЕН" # для подключения воркера к gitlab.com
```

Находясь в `infra/terraform` выполнить `terraform init` и `terraform apply`

Выполнение terraform добавит параметры подключения к k8s,  локально выполнится `yc managed-kubernetes cluster get-credentials ${yandex_kubernetes_cluster.k8s-cluster.id} --external --force`




# Status
- Добавлены Dockerfile в репозитории приложений
- Собран рабочий экземпляр приложения в docker-compose
- Написаны пайплайны с тестом и билдом (.gitlab-ci)
- Terraform в Object Storage (это важно)
- Составлена конфигурация terraform
  - Добавляет подсеть
  - Подымает k8s от yandex cloud
  - Подымает nginx-ingres в k8s через helm_release
  - Подымает gitlab в k8s через helm_release
- Подключен runner к gitlab.com

# Notes
Что бы разобраться с архитектурой приложения, зависимостями и версиями собрал контейнеры на локальной машине, а так же поднял вместе с окружением и переменными через docker-compose.

Зарегистрировался в gitlab.com, пока план держать репы тут, так как деньги на ya cloud заканчиваются.

Подключил push мирроринг репозиториев из gitlab в github, в github сливаются только "protected" бранчи репозиториев (master).

К gitlab.com подключен свой gitlab-runner, видится что это тупик и так проектную работу развивать не следует (хотя если gitlab-runner будет деплоить в кубер, то почему бы и нет), но хотел попробовать

Написал пайпы для сборки приложения
- Приложения тестируются
- Билдится docker image и пушится в docker registry (hub.docker.com) с меткой ветки
- TODO Тут очевидно должен быть ещё этап валидации (Успешное ПСИ, квалити гейты, ещё тесты)
- Релиз: из registry берётся image с тегом ветки, тегирует и пушит с новым тегом, теги latest и $(cat VERSION) как в поледнем ДЗ.
