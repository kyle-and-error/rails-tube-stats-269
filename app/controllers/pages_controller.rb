require 'google/apis/youtube_v3'
require 'google/api_client/client_secrets'
class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def data
  end

  def dashboard
    @authorization_url = authorization_url
  end

  def authorization_url
    client_secrets = Google::APIClient::ClientSecrets.load
    auth_client = client_secrets.to_authorization
    auth_client.update!(
      scope: ['https://www.googleapis.com/auth/youtube', 'https://www.googleapis.com/auth/youtube.readonly', 'https://www.googleapis.com/auth/userinfo.email'],
      redirect_uri: 'http://localhost:3000/youtube_accounts/new',
      additional_parameters: {
        "access_type" => "offline",         # offline access
        "include_granted_scopes" => "true"  # incremental auth
      }
    )
    auth_client.authorization_uri.to_s

    # client_id = Google::Auth::ClientId.from_file('/Users/kylecho/code/krenniank/rails-tube-stats-269/client_secret.json')
    # scope = ['https://www.googleapis.com/auth/youtube',
    #        'https://www.googleapis.com/auth/youtube.readonly']
    # token_store = Google::Auth::Stores::RedisTokenStore.new(redis: Redis.new)
    # authorizer = Google::Auth::WebUserAuthorizer.new(
    # client_id, scope, token_store, oauth2callback_path)

    # redirect_uri = 'http://localhost:3000/youtube_accounts/new'
    # scope = %i(youtube.readonly youtube)
    # Yt::Auth.url_for(redirect_uri: redirect_uri, scope: scope, force: true)

    # scopes = ['youtube', 'youtube.readonly', 'userinfo.email']
    # redirect_uri = 'http://localhost:3000/youtube_accounts/new'
    # Yt::Account.new(scopes: scopes, redirect_uri: redirect_uri).authentication_url
  end
end
