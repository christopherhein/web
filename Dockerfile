FROM ruby:2.3-alpine
MAINTAINER Chris Hein <me@christopherhein.com>

ENV BUILD_PACKAGES="curl-dev ruby-dev build-base bash" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev postgresql-dev git" \
    RUBY_PACKAGES="ruby-json yaml nodejs"

RUN apk update && \
    apk upgrade && \
    apk add --update\
    $BUILD_PACKAGES \
    $DEV_PACKAGES \
    $RUBY_PACKAGES && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /usr/src/app

WORKDIR /usr/src/app
COPY . /usr/src/app
EXPOSE 3000
RUN bundle config build.nokogiri --use-system-libraries && \
    bundle install && \
    bundle clean

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]