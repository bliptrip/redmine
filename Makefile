
gendockerfile:
		cp Dockerfile-afmconfig.template Dockerfile

build:
		docker build -t redmine:redmine-afmconfig -f Dockerfile .
		docker tag redmine:afmconfig bliptrip/redmine:afmconfig

push:
		docker push bliptrip/redmine:afmconfig

run:
		docker-compose up -d #Run in detached state
