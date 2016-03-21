# Rails API Starter.

A starter project for building JSON Rails APIs with JWT for Rails 4.2.6 and Ruby 2.2

### Setup

1. Make sure you have an `RAILS_ENV` environment variable set on your machine and have it set to 'development'.

2. Install your packages by running `bundle install`.

3. Make sure you have Mysql installed.

4. Create the database with `bundle exec rake db:create`
 
5. Migrate the database with `bundle exec rake db:migrate`

6. To get seed data run. `bundle exec rake db:seed`

7. You can override any environment variables such as the mysql port with a dotenv file if you wish. [Read more](https://github.com/bkeepers/dotenv)

8. Add your pre-push hook by creating a file by the name of ```.git/hooks/pre-push```
  
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
9. Run ```chmod +x .git/hooks/pre-push```

### Development

1. Start your mysql server

2. use `bundle exec rails s` to run the server.

### Testing:

Tests are written using rspec. You can run tests with the following:

  	bundle exec rspec

A sample Postman collection is provided [here](../api-resources/rest/blog-app-rest.json.postman_collection) that you can import and use for testing the API. You will need to create/use a postman environment called 'auto-token' and use the sign-in endpoint via postman. This will set your token via a 'test' for all future requests that need it. See [environments](https://www.getpostman.com/docs/environments) and [tests](https://www.getpostman.com/docs/writing_tests) for more info.

### Documentation

You may view the REST API documentation that this back-end should conform to [here](https://rawgit.com/chiedolabs/blog-app-in-many-stacks/master/back-ends/api-resources/rest/build/index.html).
