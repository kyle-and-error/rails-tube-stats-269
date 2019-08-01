class YoutubeAccountsController < ApplicationController
  DOMAIN = ENV["DOMAIN"]
  HTTP = "http"
  HTTP = "https" if DOMAIN.include?('tube-stats')
  def index
  end

  def new
    @youtube_account = YoutubeAccount.new
    authorize @youtube_account
    client_secrets = Google::APIClient::ClientSecrets.load
    auth_client = client_secrets.to_authorization
    auth_client.update!(
      scope: ['https://www.googleapis.com/auth/youtube', 'https://www.googleapis.com/auth/youtube.readonly', 'https://www.googleapis.com/auth/userinfo.email'],
      redirect_uri: "#{HTTP}://#{DOMAIN}/youtube_accounts/new",
      additional_parameters: {
        "access_type" => "offline",         # offline access
        "include_granted_scopes" => "true"  # incremental auth
      }
    )
    auth_client.code = params[:code]
    tokens = auth_client.fetch_access_token!
    @refresh_token = tokens["refresh_token"]
  end

  def create
    @youtube_account = YoutubeAccount.new(youtube_account_params)

    @youtube_account.user = current_user

    respond_to do |format|
      if @youtube_account.save
        format.html { redirect_to user_dashboard_path(current_user), notice: 'Youtube account was successfully registered.' }
        format.json { render :show, status: :created, location: @youtube_account }
      else
        format.html { render :new }
        format.json { render json: @youtube_account.errors, status: :unprocessable_entity }
      end
    end
    authorize @youtube_account
  end

  def show
  end

  def edit
    @youtube_account = YoutubeAccount.find(params[:id])
  end

  def update
    @youtube_account = YoutubeAccount.find(params[:id])
    @youtube_account.update(youtube_account_params)

    redirect_to youtube_account_path
  end

  private

  def youtube_account_params
    params.require(:youtube_account).permit(:name, :refresh_token)
  end
end
