#!/bin/bash

host=$2
host_dir="$(pwd)/$host"
thost=$host/$host.conf
ahost=/etc/apache2/sites-available/$host.conf
ehost=/etc/apache2/sites-enabled/$host.conf

remove_host_files () {
    echo "Удаление файлов виртуального хоста!"
    if [ -e $host ]
    then
        sudo rm -R $host
    fi

    if [ -e $ehost ]
    then
        sudo rm $ehost
    fi

    if [ -e $ahost ]
    then
        sudo rm $ahost
    fi

    cp /etc/hosts ./hosts
    compare=$(grep -i $host hosts)

    if [ -n "$compare" ]
    then
        newhost=$(sed '/\'$host'$/d' hosts)
        echo "$newhost" > hosts
    fi

    sudo mv hosts /etc/hosts
}

create_host_files () {

remove_host_files

echo "Создание виртуального хоста!"

# Тестовый индекс файл
html=$(cat <<EOF
<html>
    <head>
        <title>Welcome to $host</title>
    </head>
    <body>
        <h1>Hello, world!</h1>
    </body>
</html>
EOF
)

# Шаблое виртуального хоста
vhost=$(cat <<EOF
<VirtualHost *:80>
    ServerAdmin admin@$host
    ServerName $host
    ServerAlias www.$host
    DocumentRoot $host_dir
    ErrorLog $host_dir/apache_log/error.log
    CustomLog $host_dir/apache_log/access.log combined
</VirtualHost>
EOF
)

mkdir -p $host
mkdir -p $host/apache_log
chown -R $USER:$USER $host
chmod -R 755 $host

touch $host/index.html
echo "$html" > $host/index.html

touch $thost
echo "$vhost" > $thost

sudo mv $thost $ahost

sudo ln -s $ahost $ehost

cp /etc/hosts ./hosts

compare=$(grep -i $host hosts)

if [ -n "$compare" ]
then
newhost=$(sed '/\'$host'$/d' hosts)
echo "$newhost" > hosts
else
sudo echo "127.0.0.1	$host" >> hosts
sudo echo "127.0.0.1	www.$host" >> hosts
fi
sudo mv hosts /etc/hosts
sudo systemctl restart apache2
}

if [ -n "$1" ]
then
echo "Режим выполнения:"$1"."
else
echo "Не указан режим выполнения!"
exit 0
fi

if [ -n "$2" ]
then
echo "Хост:"$2"."
else
echo "Не указано имя хоста!"
exit 0
fi

case $1 in
    create|c)
          create_host_files
        ;;
    delete|d)
          remove_host_files
        ;;
    *)
          echo "Не верный режим выполнения!"
        ;;
esac