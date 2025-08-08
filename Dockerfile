FROM ruby:3.4.4

ENV RAILS_ENV production
ENV NODE_ENV production

RUN apt-get update -qq && apt-get install -y nodejs npm

RUN mkdir -p /iqvoc /iqvoc/gems /iqvoc/home /usr/sbin/.passenger /opt/nginx
RUN chown -R daemon /iqvoc /usr/sbin/.passenger /opt/nginx

WORKDIR /iqvoc
USER daemon

ENV BUNDLE_PATH /iqvoc/gems
ENV HOME /iqvoc/home
RUN gem install bundler

COPY --chown=daemon Gemfile Gemfile.lock package.json yarn.lock ./
COPY --chown=daemon config/database.yml.postgresql /iqvoc/config/database.yml

RUN bundle install --without development test
RUN yarn install --frozen-lockfile

RUN exec passenger-install-nginx-module --auto-download --auto --prefix=/opt/nginx

COPY --chown=daemon . /iqvoc

RUN DB_ADAPTER=nulldb RAILS_ENV=production bundle exec rake assets:precompile
RUN bundle exec rails webpacker:compile

EXPOSE 3000

CMD bundle exec rake db:migrate && bundle exec rake db:seed && bin/delayed_job start && exec bundle exec passenger start --port $PORT --environment $RAILS_ENV