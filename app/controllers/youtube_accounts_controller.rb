class YoutubeAccountsController < ApplicationController
  def index
  end

  def new
    @account = YoutubeAccount.new
    authorize @account
  end

  def create
    account = Yt::Account.new authorization_code: '4/Ja60jJ7_Kw0', redirect_uri: redirect_uri
    @yt_account = YoutubeAccount.new(yt_account_params)
    @yt_account.host = current_user

    respond_to do |format|
      if @yt_account.save
        format.html { redirect_to @yt_account, notice: 'Youtube account was successfully registered.' }
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
    params.require(:yt_account).permit(:name)
  end
end
