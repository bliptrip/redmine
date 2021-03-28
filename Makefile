DBF ?= redmine-databases.sql #Default database file to restore from

gendockerfile:
		cp Dockerfile-afmconfig.template Dockerfile
		cp docker-compose.template.yml docker-compose.yml
		sed -i -E -e 's/^\s+REDMINE_DB_PASSWORD:/\0 $(PASSWORD)/' docker-compose.yml
		sed -i -E -e 's/^\s+REDMINE_SECRET_KEY_BASE:/\0 $(SECRET)/' docker-compose.yml
		sed -i -E -e 's/^\s+MYSQL_ROOT_PASSWORD:/\0 $(PASSWORD)/' docker-compose.yml


build:
		docker build --no-cache -t redmine:afmconfig -f Dockerfile .
		docker tag redmine:afmconfig bliptrip/redmine:afmconfig

build_md:
		docker build --no-cache -t redmine:md_test -f Dockerfile .

push:
		docker push bliptrip/redmine:afmconfig

run:
		docker-compose up -d #Run images defined in docker-compose.yml in detached state

kill:
		docker-compose down #Shutdown running containers defined in docker-compose.yml

run_man:
		docker run -p 8080:3000 -e REDMINE_DB_MYSQL=redmine -e REDMINE_DB_USERNAME=root -e REDMINE_DB_PASSWORD="$(PASSWORD)" redmine:afmconfig

run_md_web:
	docker run -p 8080:3000 -e REDMINE_DB_MYSQL=redmine -e REDMINE_DB_USERNAME=root -e REDMINE_DB_PASSWORD="$(PASSWORD)" redmine:md_test

run_md:
	docker-compose -f docker-compose.md.yml up -d #Run in detached state

#Restore DB
db_restore:
	docker exec redmine_db sh -c 'exec mysql -uroot -p"$(PASSWORD)" < /home/redmine/tmp/$(DBF)'

db_backup:
	docker exec redmine_db sh -c 'exec mysqldump --all-databases -uroot -p"$(PASSWORD)"' > ~/tmp/redmine-databases.$$(date -I).sql

#Convert all textile-formatted notes/issues/wiki entries to markdown -- Note: This must be done after remine_web is up, as it depends on a configuration file that isn't available until the process has started
convert2md:
	docker exec redmine_web sh -c 'exec bundle exec rake convert_textile_to_markdown RAILS_ENV=production'
