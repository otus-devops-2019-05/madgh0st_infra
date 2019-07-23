# madgh0st_infra
# madgh0st Infra repository

## HW6
  * Скрипт создает необходимое количество инстансов, а так же прописывает ssh ключи
      - переменные загружаются с terraform.tfvars
      - переменные по умолчанию с variables.tf
      - ssh ключи создаются (и берутся) через terraform, если добавлять доополнительные ключи через web-интерфейс - то при следующем обновлении конфигурации добавленные ключи будут удалены!
       
        добавление нескольких ключей

        metadata = {
           sshKeys = "appuser:${file(var.ssh_public_key)}\nghost:${file(var.ssh_public_key)}"
        }

      - выходные переменные описаны в файле output.tf и могут быть выведены terraform output [название переменной]

      - sshKeys на уровне инстансов признано устаревшим, и ключи импортируются на уровне создания образов

      с load-balancer будем разбираться позже.

## HW5

   # Ознакомились с продуктом Packer
    Конфигурация образа описывается файлом json который состоит из 2 секций
        builders - построение виртуальной манины
        provisioners - ее дополнительная доводка (запуск скриптов,копирование файлов, выполнение команд

   Образ формируется на основании значений соответствующих переменных шаблона

   Генерация образов может быть кастомизирована на основании переменных.
   переменные могут быть заданы: 
      1. в основном файле json
      2. в файле с переменными  файле.packer build -var-file=variable.json immutable.json
      3. назначены в командной строке   packer build -var 'key=key' immutable.json
   значения из пунктов 2,3 переназначают значения в пункте 1


   Формирует базовый образ(Ruby,MongoDB) reddit-base
        packer build -var-file=variables.json  ./ubuntu16.json
   Формирует на основании reddit-base образ reddit-full с развернутым приложением готовым к запуску
        packer build -var-file=variables.json  ./immutable.json

    
   Скрипт create_reddit-vm.sh создает экземляр на основании семейства image-family в который подставляется последний образ данного семейства (reddit-base,reddit-full)
   

## HW4
  * в отдельной ветке перенес файлы setupvpn.sh и cloud-bastion.ovpn в папку VPN 
  * создание необходимых instances и firewall-rules (должна быть настроена учетная запись и прикркпление к проекту

    gcloud compute instances create reddit-app\
        --boot-disk-size=10GB \
        --image-family ubuntu-1604-lts \
        --image-project=ubuntu-os-cloud \
        --machine-type=g1-small \
        --tags puma-server \
        --restart-on-failure \
        --address=35.207.131.137 \
        --network-tier=STANDARD

    gcloud compute firewall-rules create default-puma-allow \
        --allow tcp:9292 \
        --source-ranges=0.0.0.0/0 \
        --source-tags=puma-server

  *  удалить созданное можно 

    gcloud compute instances create reddit-app
    gcloud compute firewall-rules create default-puma-allow

  * Файлы (deploy.sh,install_mongodb.sh,install_ruby.sh) размещены в корне репозитория, что бы тесты проходили и тревис запускал у себя обертку
  * создание файла для auto deploy

     cat install_ruby.sh install_mongodb.sh deploy.sh | grep '^#!' -v

     и к gcloud compute instances create reddit-app добавлем дополнительную опцию 
     
         --metadata-from-file startup-script=full_install.sh

    пприложение доступно по адресу https://35.207.131.137:9292

    testapp_IP = 35.207.131.137
    testapp_port = 9292

## HW3
  * Прошел регистрацию в GCP
  * Добавил ssh_key в метаданные
  * Создал два инстанса:
  - bastion (ext_ip: 35.207.131.137 , int_ip: 10.156.0.12)
  - someinternalhost (int_ip: 10.156.0.14)

  * для проброса ключей в виртуалки с только внутренним адресом подключаю агента ssh и привязываю ему приватный ключ:
  > ssh-add -i ~/.ssh/appuser

  * для прямого доступа в одну команду использую jump прыжок:
    > ssh -A -J root@35.207.131.137 root@10.156.0.14
  или
    поместив в ~/.ssh/config 

    host 10.156.0.*
        user root
        proxyCommand /usr/bin/ssh root@35.207.131.137 /bin/nc %h %p

    доступ к любому (хосту) адресу 10.156.0.* осуществляется ssh 10.156.0.* 

  #### Задание со звездочкой
    необходимо создать файл bastion_ssh.sh
    #!/usr/bin/env bash

    echo 'Connect to '$1' via 35.207.131.137'
    ssh -A -J root@35.207.131.137 root@$1


  #### VPN сервер
  ##### параметры подключения:

  bastion_IP = 35.207.131.137 
  someinternalhost_IP = 10.156.0.14

  PS pritunl делает следующие дополнительные настройки
  1) включает маршрутизацию net.ipv4.conf.all.forwarding = 1
  2) включает NAT для всей VPN сети включая доступ к внутреним сетям и сети Интернет
  
  #### SSL - задание со *
  Прописал на поднятом VPN сервере SSL сертификат, использую собственное доменное имя.
  Теперь сервер доступен по адресу: https://pritunl.tdkamilla.org

#### HW2
   * Добавлена интеграция с Travis и Slack
   * Исправлен тест на питоне (поправил Equal 1+1 = 2)
   * Добавлен шаблон для PR
