[![Build Status](https://drone.smartlogic.io/api/badges/smartlogic/smart_note/status.svg)](https://drone.smartlogic.io/smartlogic/smart_note)

# SmartNote

This is an example Phoenix application that uses [Stein](https://github.com/smartlogic/stein) to it's fullest. See how to handle common user functionality with Stein, such as auth, email verification, password resets, uploading, and more.

You can also clone this repo as a starting point for a new project to get going quickly.

## Using as a template

```bash
git grep -l SmartNote | xargs sed -i 's/SmartNote/MyApp/g'
git grep -l smart_note | xargs sed -i 's/smart_note/my_app/g'
git mv lib/{smart_note,my_app}
git mv lib/{smart_note,my_app}.ex
git mv test/{smart_note,my_app}
rm -rf .git
git init .
```

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

## Heroku

Buildpacks required:

- https://github.com/HashNuke/heroku-buildpack-elixir.git
- https://github.com/gjaldon/heroku-buildpack-phoenix-static.git
- https://github.com/oestrich/heroku-buildpack-elixir-mix-release.git

To migrate on heroku:

```bash
heroku run 'smart_note eval "SmartNote.ReleaseTasks.Migrate.run()"'
```
