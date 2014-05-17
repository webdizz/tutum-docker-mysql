#!/bin/bash
if [ -n "$MYSQL_ADMIN_CREATED" ]; then
	echo 'Skipping creating admin account on MySQL'
else
	if [ ! -f /.mysql_admin_created ]; then
		/create_mysql_admin_user.sh
	fi
fi

if [ ! -f /.root_pw_set ]; then
	  /set_root_pw.sh
fi

exec supervisord -n
