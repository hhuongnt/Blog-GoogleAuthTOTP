# Assignment: Blog app

Blog with Devise and Google Authenticator 2FA

https://boiling-cove-11931.herokuapp.com/

# Project Setup

- Clone project source
    ```
    git clone https://github.com/hhuongnt/Blog-GoogleAuthTOTP.git
    ```
- Config database
    ```
    mv config/database.yml.sample config/database.yml
    ```
- Config application
    ```
    mv config/application.yml.sample config/application.yml
    ```
- Install gem
    ```
    gem install bundler
    bundle install
    ```
- Init database
    ```
    rails db:create db:migrate db:seed
    ```
- Start server
    ```
    yarn
    bin/webpack-dev-server
    rails s
    ```
- Log in to admin
    ```
    admin@example.com / password
    ```
#
