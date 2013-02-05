# Ruby on Rails Tutorial: sample application
[![Build Status](https://secure.travis-ci.org/paulfioravanti/sample_app.png)](http://travis-ci.org/paulfioravanti/sample_app) [![Security Status](http://rails-brakeman.com/paulfioravanti/sample_app.png)](http://rails-brakeman.com/paulfioravanti/sample_app) [![Dependency Status](https://gemnasium.com/paulfioravanti/sample_app.png)](https://gemnasium.com/paulfioravanti/sample_app) [![Code Climate](https://codeclimate.com/github/paulfioravanti/sample_app.png)](https://codeclimate.com/github/paulfioravanti/sample_app)

This is the sample application for
[*Ruby on Rails Tutorial: Learn Rails by Example*](http://railstutorial.org/)
by [Michael Hartl](http://michaelhartl.com) (plus some modifications).

- This code is currently deployed [here](https://pf-sampleapp.herokuapp.com) using [Heroku](http://www.heroku.com/)
- Translation keys are currently being managed [here](http://www.localeapp.com/projects/1043) with [Localeapp](http://www.localeapp.com/).

If you find this repo useful, please help me level-up on [Coderwall](http://coderwall.com/) with an [![endorse](http://api.coderwall.com/pfioravanti/endorse.png)](http://coderwall.com/pfioravanti)

### Cloning Locally

    $ cd /tmp
    $ git clone git@github.com:paulfioravanti/sample_app.git
    $ cd sample_app
    $ bundle install
    $ bundle exec rake db:migrate
    $ bundle exec rake db:seed
    $ bundle exec rake db:test:prepare RAILS_ENV=test

### Environment Configuration

    $ cp config/application.example.yml config/application.yml

**Database**

Currently, the user/password is the same for all databases.  This can be reconfigured in **config/application.yml** and in **config/database.yml**.  Insert your databse information in **config/application.yml**

    APP_DB_NAME_DEV: # your dev db name here
    APP_DB_NAME_TEST: # your test db name here
    APP_DB_NAME_PROD: # your production db name here
    DB_USER: # your db username here
    DB_PASSWORD: # your db password here

If you do not have [Postgresql](http://www.postgresql.org/) installed on your machine (or don't use it), change the string in [line 22 of **config/database.yml**](https://github.com/paulfioravanti/sample_app/blob/master/config/database.yml#L22) to `"sqlite"` or `"mysql"`.

**Travis/Heroku**

If you're using Travis/Heroku and want to deploy this app to your own instance, do the following:

Generate a secret token:

    $ rake secret

Copy the resulting string into the `SECRET_TOKEN` entry in **config/application.yml**, then set it, along with the database values as Heroku environment variables (without the `{{ }}`):

    $ heroku config:set SECRET_TOKEN={{YOUR_SECRET_TOKEN}}
    $ heroku config:set APP_DB_NAME_PROD={{YOUR_APP_DB_NAME_PROD}} # eg: sample_app_production
    $ heroku config:set APP_DB_USER={{YOUR_APP_DB_USER}}
    $ heroku config:set APP_DB_PASSWORD={{YOUR_APP_DB_PASSWORD}}

Create encrypted travis variables for your Heroku API key and Repo name:

    $ gem install travis
    $ travis encrypt your_username/your_repo HEROKU_API_KEY={{YOUR_HEROKU_API_KEY}}
    $ travis encrypt HEROKU_GIT_URL={{YOUR_HEROKU_GIT_URL}} # eg git@heroku.com:my_app.git
    $ travis encrypt APP_DB_NAME_TEST={{YOUR_APP_DB_NAME_TEST}} # eg: sample_app_test
    $ travis encrypt APP_DB_USER={{YOUR_APP_DB_USER}}
    $ travis encrypt APP_DB_PASSWORD={{YOUR_APP_DB_PASSWORD}}

Then add them to **.travis.yml**

    env:
      global:
        - secure: {{YOUR_ENCRYPTED_HEROKU_API_KEY}}
        - secure: {{YOUR_ENCRYPTED_HEROKU_GIT_URL}}
        - secure: {{YOUR_ENCRYPTED_APP_DB_NAME}}
        - secure: {{YOUR_ENCRYPTED_APP_DB_USER}}
        - secure: {{YOUR_ENCRYPTED_APP_DB_PASSWORD}}

**Localeapp**

If you want to use Localeapp to manage language keys in the app (ignore this if you don't), [create an account](http://www.localeapp.com/users/sign_up) on their site, get an API key, and copy it into the `LOCALE_API_KEY` entry in **config/application.yml**, and add the key to your Heroku environment:

    $ heroku config:set LOCALE_API_KEY={{YOUR_LOCALE_API_KEY}}

**New Relic**

If you want to use New Relic for app metrics (ignore this if you don't), [create an account](http://newrelic.com/) on their site, get a license key, and copy it into the `NEW_RELIC_LICENSE_KEY` entry in **config/application.yml**, and add the key to your Heroku environment:

    $ heroku config:set NEW_RELIC_LICENSE_KEY={{YOUR_NEW_RELIC_LICENSE_KEY}}

- - -

## Changes from the original tutorial content:

### User Interface
- Added [Font Awesome](http://fortawesome.github.com/Font-Awesome/) icons to the header
- Added micropost character countdown based on Twitter's
- Added an endless scroll to pages with paginated lists of users or microposts, as shown in [Railscast #114 Endless Page (revised)](http://railscasts.com/episodes/114-endless-page-revised)

### i18n
- Added locale switcher
- Internationalized app labels with translations for Japanese and Italian
- All static content internationalized in [Markdown](http://daringfireball.net/projects/markdown/) files instead of HTML/ERb files
- Added i18n-specific routing
- Added translations to dynamic data and its relevant sample data (microposts) using [Globalize3](https://github.com/svenfuchs/globalize3)

### Backend
- Moved development database over to [Postgresql](http://www.postgresql.org/) to match deployment database on Heroku.
- Changed all views from HTML/ERb to [Haml](http://haml-lang.com/)
- Refactored [SCSS](http://sass-lang.com/) files to use more mix-ins, as well as additions to add styling to the language selector
- Used [rails-timeago](https://github.com/jgraichen/rails-timeago) to do time calculation for microposts on client-side rather than server-side (replaces method calls to `time_ago_in_words`)
- Simplified implementation of most forms with [SimpleForm](https://github.com/plataformatec/simple_form)
- Used [Figaro](https://github.com/laserlemon/figaro) to handle all secret keys in an attempt to remove any app-identifiable information from all environments.
- Moved mass assignment handling over to [strong_parameters](https://github.com/rails/strong_parameters) in anticipation of Rails 4.

### Testing/Debugging
- Internationalized [RSpec](http://rspec.info/) tests and further refactored them
- Refactored model specs to use [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
- Changed RSpec output to show a progress bar instead of dots using [Fuubar](https://github.com/jeffkreeftmeijer/fuubar)
- Swapped out the debug block in the footer for [rails-footnotes](https://github.com/josevalim/rails-footnotes)
- Complete refactoring of test suite to upgrade to [Capybara 2.0](https://github.com/jnicklas/capybara)
- Performance tested the RSpec test suite and as a result refactored the [**spec_helper.rb**](https://github.com/paulfioravanti/sample_app/blob/master/spec/spec_helper.rb) file.  See [this StackOverflow thread](http://stackoverflow.com/a/12215946/567863) for details.
- Added tests for [Globalize3](https://github.com/svenfuchs/globalize3) translations and expanded factories to include a micropost with its relevant translations

### Reporting/Optimizing
- Added service hooks to [Travis CI](http://travis-ci.org/), [Rails Brakeman](http://rails-brakeman.com/), [Gemnasium](https://gemnasium.com/), [Code Climate](https://codeclimate.com), [Rails Best Practices](http://railsbp.com/).  See badges under title for details.
- Used [SimpleCov](https://github.com/colszowka/simplecov) to ensure as much test coverage as possible.  Currently at 100%.
- Used [Bullet](https://github.com/flyerhzm/bullet) to optimize queries
- Added performance monitoring with [New Relic](http://newrelic.com/)

### Deployment
- Fully automatic deployment process put in place: after a commit is pushed
to Github, it gets pushed to Travis CI, and then gets deployed directly from the Travis worker to Heroku.  See [the **.travis.yml**](https://github.com/paulfioravanti/sample_app/blob/master/.travis.yml) for details and [this StackOverflow thread](http://stackoverflow.com/q/10235026/567863) for reference.

### TODOs
- Tests for Javascript-based functionality: Follow/Unfollow button, micropost countdown, endless scroll
- Tests for `strong_parameters`, if an appropriate method gets implemented before Rails 4 is released.