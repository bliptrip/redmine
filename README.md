# https://github.com/docker-library/redmine

## Maintained by: [Andrew Maule](https://github.com/docker-library/redmine).  Derivative of [the Docker Community](https://github.com/docker-library/redmine)

This is my Git repo derived from [`redmine`](https://hub.docker.com/_/redmine/).  This is intended to install redmine plugins
and my configuration on top of the default docker image.

## Generate and Edit Configuration Files

Use the Makefile to as a template to build a docker image and launch the needed images using `docker-compose`.  
To begin, make a copy of the template `Dockerfile` and `docker-compose.yml` files, but pass in the mysql password to use
and the secret by setting the following environment when invoking `make`.

```
#PASSWORD=<DB Password> SECRET=<secretfile> make gendockerfile
```

Then, edit `Dockerfile` and `docker-compose.yml` to meet your needs (or leave alone and go with defaults).  Generally,
you will more than likely edit `Dockerfile` to install new packages/plugins, and as `docker-compose.yml` should be setup
correctly

## Launch The Docker Containers

```
#make run
```

It will likely take a couple of minutes for Redmine to be available on port 8080 of the host computer.

## Restore A Previously Saved Database

To restore from a previously saved/backed up mysql database file dump, issue the following command (you will need to set
the `PASSWORD` environment variable).

```
#PASSWORD=<DB Password> DBF=<DB Filename> make db_restore
```

***NOTE:*** The `DBF` environment variable will need to be set to the mysql DB backup filename in your ~/tmp/ folder.
This ~/tmp/ folder should be bind mounted on the running `redmine_web` container under it's /home/redmine/tmp folder,
which is used to access and restore database files.

## Backup Current Redmine Database to A File
```
#PASSWORD=<DB Password> make db_restore
```

By default, it saves to ~/tmp/redmine-databases.$(date -I).sql

## Convert Previously Stored State in Textile Format to Markdown

This makes use of the [redmine_convert_textile_to_markown](https://github.com/bliptrip/redmine_convert_textile_to_markown.git) redmine plugin, which should be
installed on the running image based on `Dockerfile`.

## Kill running `docker-compose` session

```
#make kill
```
