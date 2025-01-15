FROM ruby:3.3.5-slim

RUN mkdir /app
WORKDIR /app

RUN apt-get update -qq && apt-get install -yq --no-install-recommends curl git gnupg2 \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

RUN apt-get update -qq && apt-get install -y postgresql-client zlib1g-dev liblzma-dev patch build-essential libpq-dev openssh-client \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

COPY Gemfile* ./
RUN bundle install
COPY . .

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["bin/dev"]
