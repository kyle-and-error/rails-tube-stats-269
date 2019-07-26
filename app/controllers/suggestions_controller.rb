class SuggestionsController < ApplicationController
  def index
    @suggestions = Suggestion.all
  end

  def show
    @suggestion = Suggestion.find(params[:Suggestion_id])
  end
end
