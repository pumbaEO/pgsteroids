#!/bin/bash
set -e

if [ "$1" = 'sshd' ]; then

    # look specifically for PG_VERSION, as it is expected in the DB dir
	if [ ! -s "/var/lib/barman/.barman.conf" ]; then
        cp /etc/barman.conf /var/lib/barman/.barman.conf
        chown barman:barman -R /var/lib/barman
        gosu barman barman diagnose
        #exec gosu barman barman check main
        sleep 2 
    fi
    
    if [ ! -s "/var/lib/barman/.ssh/id_rsa.pub" ]; then
        gosu barman ssh-keygen -t rsa -N '' -f /var/lib/barman/.ssh/id_rsa
    fi
    
    if [ -s "/var/lib/barman/pgssh/id_rsa.pub" ]; then
        gosu barman cat /var/lib/barman/pgssh/id_rsa.pub >> /var/lib/barman/.ssh/authorized_keys
    fi
    	/usr/sbin/sshd -D
		echo
		echo 'sshd init process complete; ready for start up.'
		echo
fi

exec "$@"
