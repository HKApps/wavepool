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
    session[:access_token]        = rdio.token[0]
    session[:access_token_secret] = rdio.token[1]
    session.delete(:request_token)
    session.delete(:request_token_secret)

    redirect_to playlists_path
  end

  def destroy
    session[:access_token]
    session[:access_token_secret]
    redirect_to :new
  end
end
