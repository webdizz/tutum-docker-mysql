FROM ubuntu:trusty
MAINTAINER Fernando Mayo <fernando@tutum.co>

# Install packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor mysql-server openssh-server pwgen

# Add image configuration and scripts
ADD start.sh /start.sh
ADD run.sh /run.sh
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD mysqld_charset.cnf /etc/mysql/conf.d/mysqld_charset.cnf
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD import_sql.sh /import_sql.sh

#SSH support
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
ADD supervisord-sshd.conf /etc/supervisor/conf.d/supervisord-sshd.conf
ADD set_root_pw.sh /set_root_pw.sh
RUN chmod +x /*.sh

EXPOSE 22
EXPOSE 3306

CMD ["/run.sh"]
