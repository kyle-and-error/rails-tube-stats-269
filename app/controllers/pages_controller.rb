require 'googleauth/web_user_authorizer'
require 'googleauth/stores/redis_token_store'
require 'redis'
class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def data
    @bar_function = ((4000.to_f / 5000.to_f) * 100).to_i
    @color_function = ""
      if @bar_function >= 75
        @color_function = 'green'
      elsif @bar_function <= 25
        @color_function = 'red'
      else
        @color_function = 'yellow'
      end
  end

  def dashboard
    @authentication_url = set_authorization_url
  end

  def google_verification
  end

  def authorize
    # NOTE: Assumes the user is already authenticated to the app
    user_id = request.session['user_id']
    credentials = authorizer.get_credentials(user_id, request)
    if credentials.nil?
      redirect authorizer.get_authorization_url(login_hint: user_id, request: request)
    end
    # Credentials are valid, can call APIs
    # ...
  end

  def oauth
    target_url = Google::Auth::WebUserAuthorizer.handle_auth_callback_deferred(
      request)
    redirect target_url
  end

  private

  def set_authorization_url
    client_id = Google::Auth::ClientId.from_file('//home/thomyturner/code/krenniank/rails-tube-stats-269/client_secret.json')
    scope = ['https://www.googleapis.com/auth/youtube',
           'https://www.googleapis.com/auth/youtube.readonly']
    token_store = Google::Auth::Stores::RedisTokenStore.new(redis: Redis.new)
    authorizer = Google::Auth::WebUserAuthorizer.new(
    client_id, scope, token_store, oauth2callback_path)

    # redirect_uri = 'http://localhost:3000/youtube_accounts/new'
    # scope = %i(youtube.readonly youtube)
    # Yt::Auth.url_for(redirect_uri: redirect_uri, scope: scope, force: true)

    # scopes = ['youtube', 'youtube.readonly', 'userinfo.email']
    # redirect_uri = 'http://localhost:3000/youtube_accounts/new'
    # Yt::Account.new(scopes: scopes, redirect_uri: redirect_uri).authentication_url
  end
end
