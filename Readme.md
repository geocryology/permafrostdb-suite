# The Permafrost Database Evironment
This package provides a containerized permafrost database environment. The environment includes the following services:

* POSTGRES + POSTGIS running a permafrost sensor & observation database
* sensorDb, a web interface for adding observations to the database

## Background
This package uses `docker compose` to create an easy-to-use instance of the permafrost database. You will need to have docker compose installed on your computer for this to work.

Docker creates two separate containers - one for the postgres database and one for the sensordb web service. The first time you launch the environment, the database will be built and populated with some device profiles. 

## Launching
To start the permafrost database environment, navigate to the same directory as the `docker-compose.yml` file and enter the following:
```bash
docker-compose up
```

To run the services in the background, add the `--detach` flag:
```bash
docker-compose up --detach
```

## Accessing
Once the services are up and running, you will be able to access the sensorDb interface through your browser. By default, sensorDb is configured to run on port `5308`. From your computer, this is reachable by `127.0.0.1:5308` in your web browser. Other people on your network 

The database container uses port `6432` (this maps to `5432` within the container). If you are connecting to the databse from your computer, you will use the address `127.0.0.1:6432`. Other people on your network should be able to access the database at `192.168.x.x:6432`. Experienced users can use the [PermafrostDB R package](https://github.com/geocryology/PermafrostDB) to interact with the database.

## Tearing down
When the docker container is stopped, the database data that has been created persists on a docker-managed volume. When you restart the docker services, you will be able to access any data that you created. However, If you want to start from scratch with a fresh database or if the database did not initialize correctly, you must first remove the volume before rebuilding. To remove the volume, use the following command:

```bash
docker-compose down --volume
```
Note that **this will delete all data in the database**
