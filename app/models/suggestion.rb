class Suggestion < ApplicationRecord
  belongs_to :watcher, class_name: 'YoutubeAccount'

  belongs_to :playlist, optional: true
  def playlist_suggestions
  belongs_to :creator, optional: true
  belongs_to :video, optional: true

  before_save :check_if_type_is_present

  def creator_suggestions
    # TODO
  end

    # TODO
  end

  def video_suggestions
    # TODO
  end

  private

  def check_if_type_is_present
    playlist || creator || video
  end
end
