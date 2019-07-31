require 'google/apis/youtube_v3'
require 'google/api_client/client_secrets'
class PagesController < ApplicationController
  DOMAIN = ENV["DOMAIN"]
  skip_before_action :authenticate_user!, only: [:home, :privacy_policy]
  before_action :authorize_url

  def home
  end

  def data
    @bar_function = ((3000.to_f / 5000.to_f) * 100).to_i
    @color_function =
      if @bar_function >= 75
        @color_function = '#4cff00'

      elsif @bar_function <= 25
        @color_function = 'red'
      else
        @color_function = '#ffa500'
      end
      @youtube_account = YoutubeAccount.new
  end

  def dashboard
    @authorization_url = authorization_url
  end

  def privacy_policy
  end

  def authorization_url
    client_secrets = Google::APIClient::ClientSecrets.load
    auth_client = client_secrets.to_authorization
    auth_client.update!(
      scope: ['https://www.googleapis.com/auth/youtube', 'https://www.googleapis.com/auth/youtube.readonly', 'https://www.googleapis.com/auth/userinfo.email'],
      redirect_uri: "http://#{DOMAIN}/youtube_accounts/new",
      additional_parameters: {
        "access_type" => "offline",         # offline access
        "include_granted_scopes" => "true"  # incremental auth
      }
    )
    auth_client.authorization_uri.to_s
  end

  private

  def authorize_url
    @authorization_url = authorization_url
  end
end
