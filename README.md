# Rails API Starter.

NO LONGER MAINTAINED. The Rails Rest portion of <a href="https://github.com/chiedolabs/blog-app-in-many-stacks/tree/master/back-ends/rails-rest">Blog App With Many Stacks</a> is now the Replacement.

A starter project for building JSON Rails APIs with JWT for Rails 4.2.6 and Ruby 2.2

### Setup

1. Make sure you have an `RAILS_ENV` environment variable set on your machine and have it set to 'development'.

1. Update config/database.yml where applicable. Mainly, you will want to change the default database name from rails_api_starter to something else.

1. Install your packages by running `bundle install`.

1. Make sure you have Mysql installed.

1. Create the database with `bundle exec rake db:create`
 
1. Migrate the database with `bundle exec rake db:migrate`

1. To get seed data run. `bundle exec rake db:seed`

1. You can override any environment variables such as the mysql port with a dotenv file if you wish. [Read more](https://github.com/bkeepers/dotenv)

1. Add your pre-push hook by creating a file by the name of ```.git/hooks/pre-push```
  
  ```
  #!/bin/bash

  echo "Tests will be run to ensure you don't break the build"
  if bundle exec rspec
  then
      exit 0 # push will execute
  fi
  echo "=================================="
  echo "Please fix the tests and commit again. If you intended to commit broken tests, then run 'git push --no-verify'"
  exit 1 # push will not execute
  ```
1. Run ```chmod +x .git/hooks/pre-push```

### Development

1. Start your mysql server

2. use `bundle exec rails s` to run the server.

### Testing:

Tests are written using rspec. You can run tests with the following:

  	bundle exec rspec

### POSTMAN

1. You can download a sample postman collection from the data directory.

### Authentication

Authentication is handled via JWT and an XSRF Token. Analyzing in postman should suffice. You will need to make sure you have the 'Interceptor' extension installed since the JWT is being sent via a cookie.
