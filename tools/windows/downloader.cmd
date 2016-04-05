@echo off

echo Скачиваю комплект дистрибутивов от PostgreSQLPro

mkdir -p c:\distrs\pg

cd c:\distrs\pg


echo Установка в "тихом" режиме не поддерживается
wget http://1c.postgrespro.ru/win/64/PostgresPro%201C_9.4.7_X64bit_1C_Setup.exe
wget http://repo.postgrespro.ru/win/32/PgAdmin3_1.22.1_X86bit_Setup.exe
echo Обратите внимание - pgAdmin собран с VSC++ Redist от версии windows 8.1 и на сервер лучше не устанавливать

echo Если вы хотите установить pgAdmin на сервер - используйте нативный pgAdmin III
wget https://ftp.postgresql.org/pub/pgadmin3/release/v1.22.1/win32/pgadmin3-1.22.1.zip


mkdir -p c:\build\pg
git clone https://github.com/postgrespro/pgwininstall c:\build\pg
