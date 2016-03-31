## "Steroids" for Infostart Webinar Users

Кому лень читать ниже, вот необходимые шаги для первоначальной настроки:

```
vagrant up
vagrant ssh
cd /vagrant
./build.sh
./run.sh
```

Включайте 1С сервер и создавайте свои базы 1С. 

```
host=ВАШ-IP port=5432 user=postgres passw=strange
```

не забудьте заглянуть на порты `8888` и `8081` c теми же пользователями и паролем

### vagrant

Найдите где скачать `vagrant`, а для удобного запуска под windows используйте оболочку [cmder](http://cmder.net/) - проще чем настраивать ключи для доступа по ssh в vagrant. 

Эти команды сделают виртуальную машины 

```
vagrant up
vagrant ssh
cd /vagrant
```

* объем выделенной оперативной памяти 2Gb
* 2 диска - расширяемых до 40gb и до 500gb

значения меняйте через Virtual Box GUI в нужную Вам сторону.

### VMWare, hyperv, virtualbox

то есть если вы не любите `vagrant`

* В виртуальную машину необходимо установить ubuntu amd 64, установить последний `docker`

* пример судобашхела, в строке `usermod -a -G docker vagrant` vagrant заменить на необходимого вам пользователя.  

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

Дочитавшие до конца могут сразу создавать папку

```
sudo mkdir /srv/zfs
```

## Ну и конечно run

ваши переменные стоит подсмотреть в файле run.sh и создать файл `.env` со своими значениями.

```
cd /vagrant
run.sh
```

* базируется на улучшенном дистриубтиве PostgreSQLPro с уточнениями

* **порт 5432** - PostgreSQLPro1C
* **порт 8081** - PgStudio
* **порт 8888** - POWA

ip на вашей машине - найдется "легко"

* база создается средствами 1С 

> сервер 1С лучше на Windows (не спрашивайте почему) и версии старше 8.3.6.1760 (смотрите свойсва libpq.dll в составе 1С платформы)

* после создания базы обратите внимание на шаблонные postgresql.conf

```
vagrant ssh
cd vagrant
cp pconf/postgresql_conf.stock # выбирать только
cp pconf/postgresql_conf.ERP # для ERP 2.1
cp pconf/postgresql_conf.UT # для Управления торговли
cp pconf/postgresql_conf.PostgreSQLPro # Удобный для быстрого старта

```

но для первых экспериментов их лучше не смотреть

### Скрипты

* Есть несколько примеров скриптов SQL `./pscripts` - позапускайте их

* Есть несколько скриптов

**пример получения bloat**

```
vagrant ssh
cd /vagrant
./vendors/bloat/pg_bloat_check.py --create_view -c "host=localhost dbname=<ИмяБазы> user=postgres password=strange"
./vendors/bloat/pg_bloat_check.py -c "host=localhost dbname=<ИмяБазы> user=postgres password=strange"
```

**пример принудительного сжатия bloat**

```
vagrant ssh
cd /vagrant
perl ./vendors/compactable/bin/pgcompacttable -h localhost -p 5432 -u postgres -w strange -d <БазуВставьте> -n public
```

### ZFS - еще больше французского сжатия

в хост системе должно оказаться большее двух блочных устройства (если вы "копипастите" код)

* в Virtual Box создается дополнительный контролер `/dev/sdb`
* указанное устройство монтируется как `zfs`
* PG будет сохранять все свои данные в нем

> если хотите отключить это замените в файле run.sh переменную $ROOT на `/srv/data` - посмотрите разницу

### Для экспериментов используйте

* Видео на Инфостарте http://infostart.ru/webinars/463095/
* Fragister конфигурацию (убийцу фрагов) http://infostart.ru/public/173394/
* Структуру просмотра имен таблиц 1C http://infostart.ru/public/147147/

`(c) allustin, pumbaEO and some secret people`

отдельная благодарность

* http://infostart.ru/
* https://github.com/postgrespro/
* https://github.com/PostgreSQL-Consulting
* https://github.com/2ndQuadrant
* http://dalibo.github.io/
