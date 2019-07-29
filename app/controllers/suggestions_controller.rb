class SuggestionsController < ApplicationController
  def index
    @suggestions = Suggestion.all
  end

  def show
  end
end
