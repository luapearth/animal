## Animal-Wires
This app is built using Ruby with Sinatra micro-framework

### Install

* `git clone https://github.com/luapearth/animal.git /your/path/appname` or `git clone https://github.com/luapearth/animal.git your-app-name`
* `cd to /your/path/appname`
Run `bundle install`

### Database
In this example I will be using `sqlite3` for simplicity.

* If prepared using MySQL database using need to create the database first, uncomment the simple code at `model.rb` that uses MySQL database and replace the credentials accordingly.

#### Database supported

* MySQL
* PostgreSQL
* Sqlite

### Setup

* Declare a site Title by replace the `SITE_TITLE` at the `const.rb`
* Replace the SALT value with something else, where going to use that SALT for session cookie.

#### Facebook Oauth

##### Obtain Facebook App ID and App Secret to be able to use the Facebook Oauth built in to this code sample.

* Visit [Facebook Developers](https://developers.facebook.com) web site and create a new app.

* Edit the `const.rb` file and replace the `APP_ID` and `APP_SECRET` value

### Run the app

* simple run the command `bundle exec rackup config.ru` in your `terminal` or `command prompt` in windows.
