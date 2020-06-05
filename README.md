[![Build Status](https://drone.smartlogic.io/api/badges/smartlogic/smart_note/status.svg)](https://drone.smartlogic.io/smartlogic/smart_note)

# SmartNote

## Docker locally

Docker is set up as a replication of production. This generates an erlang release and is not intended for development purposes.

```bash
docker-compose pull
docker-compose build
docker-compose up -d postgres
docker-compose run --rm app eval "SmartNote.ReleaseTasks.Migrate.run()"
docker-compose up app
```

You now can view `http://localhost:4000` and access the application.

## Kubernetes

To migrate on kubernetes, find a pod and exec into it and run this:

```bash
smart_note eval "SmartNote.ReleaseTasks.Migrate.run()"
```
