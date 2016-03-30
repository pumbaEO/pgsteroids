### Steroids for Infostart Webinar Users

Кому лень читать необходимые шаги для первоначальной настроки:

```
vagrant up
vagrant ssh
cd /vagrant
./build.sh
```
### vagrant

Для удобного запуска под windows используйте оболочку [cmder](http://cmder.net/) - проще чем настраивать ключи для доступа по ssh в vagrant.

```
vagrant up
vagrant ssh
cd /vagrant
```

### VMWare, hyperv, virtualbox

В виртуальную машину необходимо установить ubuntu amd 64, установить последний docker и docker-compose
пример судобашхела, в строке "usermod -a -G docker vagrant" vagrant заменить на необходимого вам пользователя.  

```
sudo -i
curl -sSL https://get.docker.com/ | sh;
usermod -a -G docker vagrant;
```
Клонируем репозитарий

```
git clone https://github.com/VanessaDockers/pgsteroids.git
cd pgsteroids
```

Создаем папку с данными

```
sudo mkdir /srv/data
```

## Ну и конечно run

ваши переменные стоит подсмотреть в файле develop.env

```
cd /vagrant
run.sh
```

* базируется на улучшенном дистриубтиве PostgreSQLPro с уточнениями

:5432 - PostgreSQLPro
:8081 - PgStudio
:8888 - POWA

ip на вашей машине

* база создается средствами 1С - сервер 1С лучше на Windows (не спрашивайте почему) и версии старше 8.3.7.1760 (смотрите свойсва libpq.dll в составе 1С платформы)
* после создания базы обратите внимание на шаблонные postgresql.conf

```
vagrant ssh
cd vagrant
cp pconf/postgresql_conf.stock # выбирать только
cp pconf/postgresql_conf.ERP # для ERP 2.1
cp pconf/postgresql_conf.UT # для Управления торговли
cp pconf/postgresql_conf.PostgreSQLPro # Удобный для быстрого старта

```

### Скрипты

* Содержат несколько примеров скриптов
  * пример получения сжатия на полях таблиц

* остальные будут появляться по мере использования
