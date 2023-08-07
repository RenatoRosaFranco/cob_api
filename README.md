# README

### Ruby version
```bash
3.0.2
``` 

### Install RBENV
```bash
sudo apt install rbenv
```

### Install Ruby with RBENV
```bash
rbenv install 3.0.2
rbenv local 3.0.2
``` 

### Rails version
```bash
7.0.6
```
  
### System dependencies
```bash
bundle install
```

### Configuration
```bash
docker-compose build --no-cache
docker-compose up # scale dev environment
docker-compose down # remove dev environment
```

### Database creation
```bash
rails db:create
```

### Database initialization
```bash
rails db:migrate
```

### How to run the test suite
```bash
bundle exec rspec -fd spec/
bundle exec rspec -fd spec/folder/
bundle exec rspec -fd spec/folder/file
bundle exec rspec spec/
```

### Inspect Project code quality and better_practices
```bash
rails_best_practices .
rubycritic .
rubocop .
```
