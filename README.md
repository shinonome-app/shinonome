# SHINONOME

## Install

### For Development Environment

```console
$ git clone https://github.com/takahashim/shinonome
$ cd shinonome
$ bundle install
$ bin/rails db:create
$ bin/rails db:migrate
$ bin/rails db:seed
$ bin/rails s
```
### For Development Environment with Docker

```console
$ git clone https://github.com/takahashim/shinonome
$ cd shinonome
$ docker-compose build
$ docker-compose run web rails db:create
$ docker-compose run web rails db:migrate
$ docker-compose run web rails db:seed
$ docker-compose up
```
