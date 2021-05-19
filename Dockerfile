FROM ruby:3.0.1-slim

RUN mkdir /app
WORKDIR /app

RUN apt-get update -qq && apt-get install -y curl

RUN curl https://deb.nodesource.com/setup_12.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get install -y nodejs yarn postgresql-client zlib1g-dev liblzma-dev patch build-essential libpq-dev git openssh-client

COPY Gemfile* ./
RUN bundle install
COPY . .

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
