class YoutubeAccountsController < ApplicationController
  def index
  end

  def new
    @youtube_account = YoutubeAccount.new
    @code = params[:code]
    authorize @youtube_account
  end

  def create
    @youtube_account = YoutubeAccount.new(youtube_account_params)
    code = params.dig(:youtube_account, :code)
    redirect_uri = "http://localhost:3000"
    auth = Yt::Auth.create(redirect_uri: redirect_uri, code: code)
    @youtube_account.user = current_user
    @youtube_account.refresh_token = auth.refresh_token

    respond_to do |format|
      if @youtube_account.save
        format.html { redirect_to dashboard_path, notice: 'Youtube account was successfully registered.' }
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

  private

  def youtube_account_params
    params.require(:youtube_account).permit(:name)
  end
end
