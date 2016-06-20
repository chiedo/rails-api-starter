source 'https://rubygems.org'

#Ruby version
ruby '2.3.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use mysql2 as the database for Active Record
gem 'mysql2', '~> 0.4.4'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# Uniquely identifies a model instance
gem 'globalid', '~> 0.3.6'

# Easily build JSON exactly how you want to to be viewed:
  # Added to make JSON responses to look exactly like Other Stacks
gem 'rabl'
# gem 'oj'
#
#
# Better rails server
gem 'puma', '~> 2.15', '>= 2.15.3'


# For Model Association Validation
gem "validates_existence", ">= 0.9.2"

# User authentication
gem 'devise', '~> 4.0.0'
gem 'jwt', '~> 1.5.4'

# For allowing CORS
gem 'rack-cors', :require => 'rack/cors'

# Duh
gem 'bcrypt', '~> 3.1'

group :development, :test do

  gem 'better_errors', '~> 2.1.1'
  # Allows you to read environment variables from a .env file
  gem 'dotenv-rails', '~> 2.1.1'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 8.2.4'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.1.1'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 1.7.1'

  # Better alternative to the standard rails testing suite
  gem 'rspec-rails', '~> 3.4.2'
  # Test double package for ruby
  gem 'mocha', '~> 1.1.0'
  # provides a framework and DSL for defining and using factories - less error-prone, more explicit, and all-around easier to work with than fixtures.
  gem 'factory_girl', '~> 4.7.0'

  # Generates fake data for tests
  gem 'faker', '~> 1.6.3'

  # For cleaning out the database
  gem 'database_cleaner', '~> 1.5.3'
end

group :test do
  # For if you choose to run your tests using an in-memory database.
  # You may or may not use this but doesn't hurt to have it here.
  gem 'sqlite3', '~> 1.3.11'
  # Needed to make sqlite in-memory work smoothly
  gem 'memory_test_fix', '~> 1.3.0'
end


