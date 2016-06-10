class TweetsController < ApplicationController

  def index
    @tweets = current_user.tweets
  end
end
