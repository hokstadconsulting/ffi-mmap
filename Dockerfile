# -*- sh -*-
FROM debian:jessie
RUN apt-get update
RUN apt-get -y install ruby ruby-dev build-essential git

RUN gem install -n /usr/bin bundler
RUN gem install -n /usr/bin rake

VOLUME ["/config"]
EXPOSE 8080

WORKDIR /app
ADD Gemfile* /app/
ADD lib/ /app/lib
ADD spec/ /app/spec/

