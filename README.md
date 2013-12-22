# Sample App

A rails Sample App from [*Rails Tutorial*](http://ruby.railstutorial.org)

## OBS
To create a new app without the test directory:
>`$ rails new sample_app --skip-test-unit`

In order to configure Rails to use RSpec:
>`$ rails generate rspec:install`

## Deploy on Heroku
> `$ heroku create`
> `$ git push heroku master`
> `$ heroku run rake db:migrate`

To watch for the heroku's log:
> `$ heroku logs`

To generate the StaticPages controller (home and help are the actions!):
> `$ rails generate controller StaticPages home help --no-test-framework`

To undo:
> `$ rails destroy controller StaticPages home help`

To generate the integration test
> `$ rails generate integration_test static_pages`

To execute the tests:
> `$ bundle exec rspec spec/requests/static_pages_spec.rb`

> `$ rails generate controller Users new --no-test-framework`

> `$ rails generate integration_test user_pages`

> `$ rails generate migration add_index_to_users_email`
