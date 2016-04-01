#/bin/sh

echo Get the laster postgrespro patch for 1C

git clone https://github.com/postgrespro/pgwininstall /tmp/pgwininstall

cp -r /tmp/pgwininstall/patches/postgresql/9.5.1 ../
