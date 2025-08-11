web: bundle exec passenger start --port $PORT --environment $RAILS_ENV
worker: bundle exec rake jobs:work
release: bundle exec rails db:migrate