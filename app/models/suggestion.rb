class Suggestion < ApplicationRecord
  belongs_to :watcher, class_name: 'YoutubeAccount'

  belongs_to :playlist, optional: true
  belongs_to :creator, optional: true
  belongs_to :video, optional: true

  before_save :check_if_type_is_present

  def self.create_subscribe_suggestions(watcher, datetime)
    watches = Watch.where(watcher: watcher).where(subscription: false).to_a

    watches.sort do |a, b|
      b.watch_time_since(3.days.before(datetime)) <=> a.watch_time_since(3.days.before(datetime))
    end
    watches.each do |watch|
      message = "We reccomend that you subscribe to #{watch.creator}. You have watched them for a total of #{a.readable_watch_time_since(3.days.before(datetime))} since #{3.days.before(datetime)}."
      Suggestion.create!(watcher: watcher, type: "Channel", action: "Subscribe", creator: watch.creator, message: message)
    end
  end

  def self.create_unsubscribe_suggestions(watcher, datetime)
    # TODO
    watches = Watch.where(watcher: watcher).where(subscription: true).to_a
    watches.select! do |watch|
      datetime >= watch.latest_watched_video.datetime_watched
    end
    sub_time = 0
    watches.each do |watch|
      sub_time += watches.watch_time_since(datetime)
    end
    quota = sub_time / (3 * watches.count)
    watches.select! do |watch|
      watch.watch_time_since(datetime) <= quota
    end
    watches.sort do |a, b|
      a.watch_time_since(datetime) <=> b.watch_time_since(datetime)
    end
    watches.each do |watch|
      message = "We reccomend that you unsubscribe from #{watch.creator}. "
      Suggestion.create!(watcher: watcher, type: "Channel", action: "Unsubscribe", creator: watch.creator, message: message)
    end
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
