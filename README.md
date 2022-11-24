# SHINONOME

## Install

### For Development Environment

```console
$ git clone https://github.com/takahashim/shinonome
$ cd shinonome
$ bundle install
$ bin/rails db:create
$ bin/rails db:migrate
$ bin/rails db:seed USE_ALL_SEEDS=1
$ bin/rails s
```
### For Development Environment with Docker

```console
$ git clone https://github.com/takahashim/shinonome
$ cd shinonome
$ docker-compose build
$ docker-compose run app rails db:create
$ docker-compose run app rails db:migrate
$ docker-compose run app rails db:seed USE_ALL_SEEDS=1
$ docker-compose up
```


### Env Var

You must define these environment variables.

* `SITE_NAME`: the site name
* `MAIN_SITE_URL`: the url for main site
