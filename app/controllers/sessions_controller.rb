require 'rdio'

class SessionsController < ApplicationController

  def new
    rdio = Rdio.new([ENV["RDIO_CONSUMER_KEY"], ENV["RDIO_CONSUMER_SECRET"]])
    @url = rdio.begin_authentication("#{root_url}auth/rdio/callback")
    session[:request_token] = rdio.token[0]
    session[:request_token_secret] = rdio.token[1]
  end

  def create
    rdio = Rdio.new([ENV["RDIO_CONSUMER_KEY"], ENV["RDIO_CONSUMER_SECRET"]],
                    [session[:request_token], session[:request_token_secret]])
    rdio.complete_authentication(params[:oauth_verifier])

    session.delete(:request_token)
    session.delete(:request_token_secret)

    user = User.where(rdio_key: rdio.call('currentUser')['result']['key']).first_or_initialize do |u|
      u.access_token        = rdio.token[0]
      u.access_token_secret = rdio.token[1]
    end

    if user.save
      session[:user_id] = user.id
      redirect_to playlists_path
    else
      render :new, notice: "Something went wrong :("
    end
  end

  def destroy
    current_user.clear_tokens!
    redirect_to :root
  end
end
