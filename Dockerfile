FROM ruby:latest

WORKDIR /app

RUN apt-get install && apt-get install -y \
    build-essential \
    nodejs \
    sqlite3 \
    libsqlite3-dev

RUN gem install rails -v '7.0.6'

COPY Gemfile Gemfile.lock

RUN bundle install

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
