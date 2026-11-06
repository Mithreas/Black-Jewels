docker stop BlackJewelsTest
docker rm BlackJewelsTest

docker stop MariaDB
docker rm MariaDB

docker run --name MariaDB ^
           --net host ^
           -v "c:\users\james\documents\neverwinter nights\maria-db":/var/lib/mysql ^
		   -e MYSQL_ROOT_PASSWORD=MyReallySecurePassword ^
		   -d mariadb:latest

docker run --restart unless-stopped -dit ^
    --net host ^
	-p 5121:5121 ^
	-e NWN_PORT=5121 ^
    --name BlackJewelsTest ^
    -v "c:\users\james\documents\neverwinter nights":/nwn/home ^
	-v "c:\users\james\documents\neverwinter nights\logs":/nwn/run/logs.0 ^
    -e NWN_MODULE=BlackJewels ^
    -e NWN_PUBLICSERVER=1 ^
    -e NWN_SERVERNAME="Black Jewels Test [no nwsync yet]" ^
    -e NWN_PLAYERPASSWORD=T3st925# ^
    -e NWN_DMPASSWORD=DMT3st925# ^
    -e NWN_ELC=0 ^
    -e NWN_ILR=0 ^
    -e NWN_MAXLEVEL=15 ^
    -e NWN_GAMETYPE=10 ^
    -e NWN_PAUSEANDPLAY=0 ^
    -e NWN_NWSYNCURL="" ^
    -e NWNX_ADMINISTRATION_SKIP=n ^
    -e NWNX_BEHAVIOURTREE_SKIP=y ^
    -e NWNX_CHAT_SKIP=n ^
    -e NWNX_CREATURE_SKIP=n ^
    -e NWNX_COMBATMODES_SKIP=n ^
    -e NWNX_EFFECT_SKIP=n ^
    -e NWNX_EVENTS_SKIP=n ^
    -e NWNX_ITEM_SKIP=n ^
    -e NWNX_METRICS_INFLUXDB_SKIP=y ^
    -e NWNX_NAMES_SKIP=y ^
    -e NWNX_OBJECT_SKIP=n ^
    -e NWNX_PLAYER_SKIP=n ^
    -e NWNX_RENAME_SKIP=n ^
    -e NWNX_RENAME_OVERWRITE_DISPLAY_NAME=false ^
    -e NWNX_RENAME_ALLOW_DM=true ^
    -e NWNX_RUBY_SKIP=n ^
    -e NWNX_RUBY_PRELOAD_SCRIPT='../../../home/ruby/extern.rb' ^
    -e NWNX_RUBY_EVALUATE_METRICS=true ^
    -e NWNX_SERVERLOGREDIRECTOR_SKIP=y ^
    -e NWNX_SQL_SKIP=n ^
    -e NWNX_THREADWATCHDOG_SKIP=y ^
    -e NWNX_TRACKING_SKIP=n ^
    -e NWNX_SQL_TYPE=mysql ^
    -e NWNX_SQL_HOST=127.0.0.1 ^
    -e NWNX_SQL_USERNAME=nwn ^
    -e NWNX_SQL_PASSWORD=B1gH1pp0 ^
    -e NWNX_SQL_DATABASE=nwn ^
    -e NWNX_SQL_QUERY_METRICS=true ^
    -e NWNX_SQL_CHARACTER_SET=utf8 ^
    -e NWNX_SQL_USE_UTF8=true ^
    -e NWNX_TWEAKS_SKIP=n ^
    -e NWNX_TWEAKS_HIDE_CLASSES_ON_CHAR_LIST=true ^
    -e NWNX_TWEAKS_DISABLE_PAUSE=true ^
	-e NWNX_TWEAKS_SEND_TLK_OVERRIDE_BEFORE_CHARGEN=true ^
    -e NWNX_VISIBILITY_SKIP=n ^
    -e NWNX_WEAPON_SKIP=n ^
    -e NWNX_TWEAKS_PARRY_ALL_ATTACKS=true ^
    -e NWNX_CORE_LOG_LEVEL=6 ^
    nwnxee/unified:latest