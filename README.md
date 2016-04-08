## "Steroids" for Infostart Webinar Users

> у каждого разработчика 1С - должен стоять локально PostgreSQL, чтобы не расслабляться 

Кому лень читать ниже, вот необходимые шаги для первоначальной настроки:

* скачать Vagrant https://www.vagrantup.com
* скачать VirtualBox https://www.virtualbox.org/wiki/Downloads
* скачать git (msgit) https://git-for-windows.github.io/

установить вышеуказанные программы и запустить командную строку в каталоге для эксперментов, в которой выполнить:

```
git clone https://github.com/VanessaDockers/pgsteroids.git
cd pgsteroids
vagrant up
vagrant ssh
cd /vagrant
./build.sh
./run.sh
```

Включайте 1С сервер и создавайте свои базы 1С.

* сервер 1С лучше использовать в виде запуска из командной строки
* запускать через командную строку `ragent <параметры сервера>` (если вы не знаете как задать параметры ragent этот репозиторий не для Вас)

адрес подключения сервера PostgreSQL

```
host=ВАШ-IP port=5432 user=postgres passw=strange
```

не забудьте заглянуть на порты `8888` и `8081` c теми же пользователем и паролем

Текущий релиз `0.4` содержит

* 2 образа - 9.4.7 и 9.5.2
* 1 образ - кластер CitusData на базе образа 9.5.2

и дополнительно включенные необходимые для 1С расширения.

[![Открытый чат проекта https://gitter.im/VanessaDockers/pgsteroids](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/VanessaDockers/pgsteroids?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

### vagrant

Для удобного запуска под windows используйте оболочку [cmder](http://cmder.net/) - проще чем настраивать ключи для доступа по ssh в vagrant.

Эти команды сделают виртуальную машину

```
vagrant up
vagrant ssh
cd /vagrant
```

* объем выделенной оперативной памяти 2Gb (можно менять в `Vagrantfile`)
* 3 диска - расширяемых до 300gb

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

Создаем 3 папки с данными

```
sudo mkdir -p /srv/main
sudo mkdir -p /srv/second
sudo mkdir -p /srv/extension

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

все службы находятся на **внешнем** IP вашего проверочного комьютера

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

но для первых экспериментов их лучше не смотреть, а сделать запуск тюнинга конфигурационного файла


### Скрипты

Несколько примеров скриптов SQL `./pscripts` - позапускайте их

* для просмотра сжатия колонок вашей базы
* для поиска отсутствующих индексов

Управляющие скрипты администратора

* **пример получения bloat**

```
vagrant ssh
cd /vagrant
./vendors/bloat/pg_bloat_check.py --create_view -c "host=localhost dbname=<ИмяБазы> user=postgres password=strange"
./vendors/bloat/pg_bloat_check.py -c "host=localhost dbname=<ИмяБазы> user=postgres password=strange"
```

* **пример принудительного сжатия bloat**

```
vagrant ssh
cd /vagrant
perl ./vendors/compactable/bin/pgcompacttable -h localhost -p 5432 -u postgres -w strange -d <БазуВставьте> -n public
```

* **пример построения статистики использования для анализа**

```
vagrant ssh
cd /vagrant
./tools/checkpoint-reports.sh
```

отчет возникнет в каталоге `./temp/wwwreports/out.html

для администраторов - 2 скрипта

* вход в ssh PG хоста - `./tools/enter-to-pg.sh`
* вход в `psql` PG хоста - `./tools/enter-to-psql.sh`


### ZFS - еще больше французского сжатия

в хост системе должно оказаться большее двух блочных устройства (если вы "копипастите" код)

* в Virtual Box создается дополнительный контролер `/dev/sdb`
* указанное устройство монтируется как `zfs`
* PG будет сохранять все свои данные в нем

> если хотите отключить это замените в файле run.sh переменную $ROOT на `/srv/data` - посмотрите разницу

### Для экспериментов используйте

* Видео на Инфостарте http://infostart.ru/webinars/463095/
* Структуру просмотра имен таблиц 1C http://infostart.ru/public/147147/

#### Список конфигураций и публикаций для тестирования 1С

* Fragister конфигурацию (убийцу фрагов) http://infostart.ru/public/173394/
* "Тест Гилева" http://www.gilev.ru/tpc1cgilv/
* статью "Нагрузочное тестирование 1С:Документооборот" http://infostart.ru/public/440094/

и другие тестовые конфигурации

### Список расширений PostgreSQL

* pg_prewarm
* pg_befferscache
* etc (TODO)

### Цели, авторы, благодарности

мы считаем что разработчик 1С должен проверять свои решения под работой не только MSSQL, но и PostgreSQL. Для быстроты запуска такого контура и создан этот репозиторий.

`(c) allustin, pumbaEO and some secret people`

отдельная благодарность

* http://infostart.ru/
* https://github.com/postgrespro/
* https://github.com/PostgreSQL-Consulting
* https://github.com/2ndQuadrant
* http://dalibo.github.io/
