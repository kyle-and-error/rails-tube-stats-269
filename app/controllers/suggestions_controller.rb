class SuggestionsController < ApplicationController
  def index
    datetime = 1.year.ago
    youtube_account = 1
    byebug
    Suggestion.create_suggestions(YoutubeAccount.find_by_id, datetime)
    @channel_suggestions = Suggestion.where(watcher: youtube_account, type: "Channel")
    @video_suggestions = Suggestion.where(watcher: youtube_account, type: "Video")
  end

  def show
  end
end
