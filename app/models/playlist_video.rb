class PlaylistVideo < ApplicationRecord
  belongs_to :video
  belongs_to :playlist

  def initialize(list, item)
    self.playlist = list
    self.video = init_video(list, item.video_id)
  end
end
