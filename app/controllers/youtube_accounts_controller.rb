class YoutubeAccountsController < ApplicationController
  def index
  end

  def new
    @yt_account = YoutubeAccount.new
    @code = params[:code]
    authorize @yt_account
  end

  def create
    @youtube_account = YoutubeAccount.new(youtube_account_params)
    @youtube_account.user = current_user


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
    params.require(:youtube_account).permit(:name, :code)
  end
end
