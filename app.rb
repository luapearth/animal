require 'bundler'
require './model'
require './const'

Bundler.require(:default)


# helpers for escaping html tag
helpers do
    include Rack::Utils
    alias_method :h, :escape_html
end


class AnimalFlitter < Sinatra::Application
	enable :sessions
	configure do
	  set :session_secret, SALT
	end

	#use Rack::Session::Cookie, secret: SALT

	def get_current_user user_id
		User.get user_id
	end

	def find_user username
		User.first(:username => username)
	end

	def set_session u
		session['user_name'] = u.full_name
		session['user_id'] = u.id

		u.last_activity = Time.now
		u.save
	end

	# home page, redirect user if already logged

	get '/' do
		if session['user_id']
			redirect '/animal'
		end

		# facebook login: Koala gem for api and oauth
		# obtain user token first to retrieve user info.
		if session['access_token']
			@graph = Koala::Facebook::API.new(session['access_token'])

			profile = @graph.get_object("me")
			localuser = profile['first_name']
			u = find_user localuser
			if u.nil?
				nu = User.create :username => localuser, :password => profile['id'], :full_name => profile['name'], :last_activity => Time.now
				
				set_session nu
				redirect '/animal'
			else
				set_session u

				redirect '/animal'
			end
		else
			@title = SITE_TITLE
			erb :login
		end
	end

	# user login
	post '/login' do
		if params[:username] != "" && params[:password] != ""
			"Hello World"
		else
			flash[:error] = "Username or Password cannot be empty"
			redirect back
		end
		# u = find_user params['username']
		# if u.nil?
		# 	redirect '/'
		# elsif u.authenticate(params['password'])
		# 	set_session u

		# 	redirect '/animal'
		# else
		# 	redirect '/'
		# end
	end

	# logout user and redirect to home page
	get '/logout' do
		session.clear
		redirect '/'
	end

	# register new user and redirect to /animal page after
	# registration is complete
	post '/register' do
		u = find_user params['reg_username']
		if u.nil?
			nu = User.create(:username => params['reg_username'], :password => params['reg_password'], :full_name => params['reg_fullname'])
			if !nu.errors.nil?
				nu.errors.each do |e|
					puts "#{e}"
				end
			end
			if !nu.nil?
				set_session nu
				redirect '/animal'
			else
				redirect '/'
			end
		end
	end

	# user landing page: if user is autheticated it will display the user
	# post and the text field for new post
	# else /animal display's all the users register in the site
	get '/animal' do
		@title = SITE_TITLE
		if session['user_id']
			@user = get_current_user session['user_id']
			@count = @user.posts.count if !@user.nil?
			erb :animal	
		else
			@users = User.all
			erb :list
		end
	end

	# facebook login page for obtaining user token
	get '/fblogin' do
    # generate a new oauth object with your app data and your callback url
    session['oauth'] = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET, "#{request.base_url}/fb/callback")
    # redirect to facebook to get your code
    redirect session['oauth'].url_for_oauth_code()
  end

  # landing page for facebook callback
  get '/fb/callback' do
  	session['access_token'] = session['oauth'].get_access_token(params[:code])
		redirect '/'
  end

  # new post page handles the creatation of new post
  # this is call using jquery ajax
  post '/newpost' do
  	@user = get_current_user session['user_id']

  	p = Post.create(:body => params['postbody'], :created_at => Time.now, :user => @user)
  	@user.posts.reload
  end

  # animal user splat handle user search
  # display all post associated to the user
  get '/animal/user/:username' do
  	@title = SITE_TITLE
  	@user = find_user params[:username]
  	erb :userpost
  end

end
