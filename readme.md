## Animal-Wires
This app is built using Ruby with Sinatra micro-framework

### Install

* `git clone https://github.com/luapearth/animal.git /your/path/appname` or `git clone https://github.com/luapearth/animal.git your-app-name`
* `cd to /your/path/appname`
* Run `bundle install`

### Database
In this example I will be using `sqlite3` for simplicity.

* If prepared using MySQL database using need to create the database first, uncomment the example code at `model.rb` that uses MySQL database and replace the credentials accordingly also edit the `Gemfile` and uncomment `gem mysql2` and `gem dm-mysql-adapter`.

* No need to worry for the database schema, data_mapper gem will do the job.

#### Database supported

* MySQL
* PostgreSQL
* Sqlite

#### Facebook Oauth (optional)

##### Obtain Facebook App ID and App Secret to be able to use the Facebook Oauth built in to this code sample.

* Visit [Facebook Developers](https://developers.facebook.com) web site and create a new app.

Add the following code to your `const.rb` file and replace the value of `APP_ID` and `APP_SECRET` that you get from your facebook app.

```ruby
# facebook app id
APP_ID = 12334345462
# facebook app secret
APP_SECRET = 'd1cd3c....'
```

Find the following code in `app.rb` file and uncomment if your going to use facebook oauth
```ruby
if session['access_token']
	@graph = Koala::Facebook::API.new(session['access_token'])

	profile = @graph.get_object("me")

	#............
end

get '/fblogin' do
	#............
end

get '/fb/callback' do
	#............
end
```

At `views/login.erb` uncomment the following line of code
```html
<div class="form-group">
	<a href="/fblogin" class="btn btn-wide btn-fb"><i class="fa fa-facebook-official"></i> Sign in using Facebook</a>
</div>
```

### Run the app

* simply run the command `bundle exec rackup config.ru` in your `terminal` or `command prompt` in windows.
* visit the running site @ [http://localhost:9292](http://localhost:9292)

* For any issues / suggestions please email johnpaul.g.delmundo@gmail.com *
