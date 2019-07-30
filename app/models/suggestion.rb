class Suggestion < ApplicationRecord
  belongs_to :watcher, class_name: 'YoutubeAccount'

  belongs_to :playlist, optional: true
  belongs_to :creator, optional: true
  belongs_to :video, optional: true

  before_save :check_if_type_is_present

  def self.create_subscribe_suggestions(watcher)
    # TODO
    watches = Watch.where(watcher: watcher).where(subscription: false).to_a

    watches.sort do |a, b|
      b.total_watch_time <=> a.total_watch_time
    end
  end

  def self.create_unsubscribe_suggestions(watcher)
    # TODO
    watches = Watch.where(watcher: watcher).where(subscription: true).to_a
    watches.select! { |watch|
      one_month = 1.months.ago >= watch.latest_watched_video.datetime_watched
    }
    watches << Watch.least_watched_by(watcher)
  end
  def self.create_playlist_suggestions
    # TODO
  end

  def self.create_video_suggestions
    # TODO
  end

  private

  def check_if_type_is_present
    playlist || creator || video
  end
end
