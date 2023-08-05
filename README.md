# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
3.0.2

* Install RBENV
sudo apt install rbenv

* Install Ruby with RBENV
rbenv install 3.0.2
rbenv local 3.0.2

* Rails version
7.0.6
  
* System dependencies
bundle install

* Configuration
docker-compose build --no-cache
docker-compose up
docker-compose down

* Database creation
rails db:create

* Database initialization
rails db:migrate

* How to run the test suite
bundle exec rspec -fd spec/
bundle exec rspec -fd spec/folder/
bundle exec rspec -fd spec/folder/file
bundle exec rspec spec/

* Inspect Project code quality and better_practices
rails_best_practices .
rubycritic .
rubocop .

* ...
