class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def data
  end

  def dashboard
    @authentication_url = set_authorization_url
  end

  def google_verification
  end

  private

  def set_authorization_url
    scopes = ['youtube', 'youtube.readonly', 'userinfo.email']
    redirect_uri = 'http://localhost:3000/youtube_accounts/create'
    Yt::Account.new(scopes: scopes, redirect_uri: redirect_uri).authentication_url
  end
end
