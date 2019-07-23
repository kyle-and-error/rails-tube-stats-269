class Suggestion < ApplicationRecord
  belongs_to :playlist, optional: true
  belongs_to :creator, class_name: 'YoutubeAccount', optional: true
  belongs_to :video, optional: true

  before_save :check_if_type_is_present

  private

  def check_if_type_is_present
    playlist || creator || video
  end
end
