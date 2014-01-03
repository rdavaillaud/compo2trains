#/bin/bash
set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"
DIR="$(pwd)"
APPS=${APPS:-/mnt/apps}

killz(){
	echo "Killing all docker containers:"
	docker ps
	ids=`docker ps | tail -n +2 |cut -d ' ' -f 1`
	echo $ids | xargs docker kill
	echo $ids | xargs docker rm
}

stop(){
	echo "Stopping all docker containers:"
	docker ps
	ids=`docker ps | tail -n +2 |cut -d ' ' -f 1`
	echo $ids | xargs docker stop
	echo $ids | xargs docker rm
}

start(){
  FRONT=$(docker run \
		-d \
		-p 80:80 \
		-v $DIR:/home/docker/compo2trains \
		-name=compo2trains \
		rdavaillaud/compo2trains)
	echo "Started FRONT in container $FRONT"

	sleep 1
}

build(){
  docker build -t "rdavaillaud/compo2trains" .
}

issh(){
  IP=$(docker inspect compo2trains | grep IPAddress | cut -d '"' -f 4)
  ssh docker@$IP
}

update(){
	#~ apt-get update
	#~ apt-get install -y lxc-docker
#~
	#~ docker pull server:4444/front
  sleep 1
}

case "$1" in
	restart)
		killz
		start
		;;
	start)
		start $2
		;;
  build)
    build $2
    ;;
	stop)
		stop
		;;
	kill)
		killz
		;;
	update)
		update
		;;
	status)
		docker ps
		;;
	clean)
		docker rm front bdd
		;;
	clean-all)
		docker rm `docker ps -a -q`
		;;
  ssh)
    issh $2
    ;;
	*)
		echo $"Usage: $0 {start|stop|kill|update|restart|status|ssh|clean|clean-all|buildbase}"
		RETVAL=1
esac
