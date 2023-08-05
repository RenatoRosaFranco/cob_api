FROM ruby:3.0.2

ENV RAILS_ENV=production

RUN apt-get update -qq && apt-get install -y nodejs sqlite3 libsqlite3-dev

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler
RUN bundle install --jobs 4

COPY . .

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]