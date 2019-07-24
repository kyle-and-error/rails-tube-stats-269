class YoutubeAccountsController < ApplicationController
  def index
  end

  def new
    @yt_account = YoutubeAccount.new
    @code = params[:code]
    authorize @yt_account
  end

  def create
    @yt_account = YoutubeAccount.new(name: params[:name], code: params[:code])
    @yt_account.user = current_user

    respond_to do |format|
      if @yt_account.save
        format.html { redirect_to dashboard_path, notice: 'Youtube account was successfully registered.' }
        format.json { render :show, status: :created, location: @yt_account }
      else
        format.html { render :new }
        format.json { render json: @yt_account.errors, status: :unprocessable_entity }
      end
    end
    authorize @yt_account
  end

  def show
  end

  private

  def yt_account_params
    params.require(:yt_account).permit(:name, :code)
  end
end
