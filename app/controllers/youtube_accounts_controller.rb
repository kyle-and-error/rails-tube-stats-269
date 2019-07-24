class YoutubeAccountsController < ApplicationController
  def index
  end

  def new
    @account = YoutubeAccount.new
    authorize @account
  end

  def create
    @event = Event.new(event_params)
    @event.host = current_user

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
    authorize @event
  end

  def show
  end
end
