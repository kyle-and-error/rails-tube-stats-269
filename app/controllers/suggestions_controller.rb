class SuggestionsController < ApplicationController
  def index
    @channel_suggestions = Suggestion.where(type: "Channel")
    @video_suggestions = Suggestion.where(type: "Video")
  end

  def show
  end
end
