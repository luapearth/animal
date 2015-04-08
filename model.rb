require 'data_mapper'
require 'bcrypt'

DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite://#{Dir.pwd}/animal_wires.sqlite"))
# DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://host/databasename')
# DataMapper.setup(:default, (ENV['DATABASE_URL'] || 'mysql://username:password@host/databasename'))

# User table definition
class User
	include DataMapper::Resource
	include BCrypt

	property :id, Serial, :key => true
	property :username, String, :length => 3..50
	property :password, BCryptHash
	property :full_name, String
	property :last_activity, DateTime

	has n, :posts

	def authenticate(attempted_password)
		if self.password == attempted_password
			true
		else
			false
		end
	end
end

# Post table definition
class Post
	include DataMapper::Resource

	property :id, Serial, :key => true
	property :body, Text
	property :created_at, DateTime

	belongs_to :user
end
DataMapper.finalize
DataMapper.auto_upgrade!
