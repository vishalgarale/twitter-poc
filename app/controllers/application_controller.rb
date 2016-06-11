class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_twitter, if: :twitter? 

  def after_sign_in_path_for(resource)
	session[:twitter] = false
	root_url
  end

  def set_twitter
  	@twitter = Twitter::REST::Client.new do |config|
	  config.consumer_key = CONSUMER_KEY
	  config.consumer_secret = CONSUMER_SECRET
	  config.access_token = current_user.access_token
	  config.access_token_secret = current_user.access_token_secret
	end
	current_user.tweets.destroy_all
	@twitter.home_timeline.each do |tweet|
	  current_user.tweets.create(message: tweet.full_text, url: tweet.uri)
        end
	session[:twitter] = true
  end

  def twitter?
  	return false unless current_user
  	!session[:twitter]
  end
end
