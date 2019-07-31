class Suggestion < ApplicationRecord
  belongs_to :watcher, class_name: 'YoutubeAccount'

  belongs_to :playlist, optional: true
  belongs_to :creator, optional: true
  belongs_to :video, optional: true

  before_save :check_if_type_is_present

  def self.create_suggestions(watcher, datetime)
    Suggestion.create_channel_suggestions(watcher, datetime)
    Suggestion.create_video_suggestions(watcher)
  end

  def self.create_channel_suggestions(watcher, datetime)
    Suggestion.create_subscribe_suggestions(watcher, datetime)
    Suggestion.create_unsubscribe_suggestions(watcher, datetime)
  end

  def self.create_subscribe_suggestions(watcher, datetime)
    watches = Watch.where(watcher: watcher).where(subscription: false).to_a

    watches.sort do |a, b|
      b.watch_time_since(3.days.before(datetime)) <=> a.watch_time_since(3.days.before(datetime))
    end
    watches.each do |watch|
      sugg = Suggestion.where(watcher: watcher, creator: watch.creator).take
      message = "We reccomend that you subscribe to #{watch.creator}. You have watched them for a total of #{a.readable_watch_time_since(3.days.before(datetime))} since #{3.days.before(datetime)}."
      if sugg.nil?
        Suggestion.create!(watcher: watcher, type: "Channel", action: "Subscribe", creator: watch.creator, message: message)
      else
        sugg.message = message
        sugg.save!
      end
    end
  end

  def self.create_unsubscribe_suggestions(watcher, datetime)
    # Could use some refinement, but it works
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
      sugg = Suggestion.where(watcher: watcher, creator: watch.creator).take
      message = "We reccomend that you unsubscribe from #{watch.creator}. "
      if sugg.nil?
        Suggestion.create!(watcher: watcher, type: "Channel", action: "Unsubscribe", creator: watch.creator, message: message)
      else
        sugg.message = message
        sugg.save!
      end
    end
    # Suggestion.create! << Watch.least_watched_by(watcher)
  end

  def self.create_playlist_suggestions
    # TODO

  end

  def self.create_video_suggestions(watcher)
    # TODO
    watched_videos = WatchedVideo.where(watch: Watch.where(watcher: watcher)).to_a
    array_video = array.map {|wv| wv.video}
    array_video.unique!
    videos_count = Hash.new(0)
    array_video.each do |v|
      watched_videos.each do |wv|
        if wv.video == v
          suggested_videos[v] += 1
        end
      end
    end
    videos_count.each do |video, count|
      if count > 4
        message = "You should add this to a playlist, for easy access. You have watched it #{count} times."
        sugg = Suggestion.where(watcher: watcher, video: video, action: "Add to playlist").take
        if sugg.nil?
          Suggestion.create!(watcher: watcher, type: "Video", action: "Add to playlist", video: video, message: message)
        else
          sugg.message = message
        end
      elsif count > 2
        message = "You should like this video!"
        sugg = Suggestion.where(watcher: watcher, video: video, action: "Like").take
        if sugg.nil?
          Suggestion.create!(watcher: watcher, type: "Video", action: "Like", video: video, message: message)
        else
          sugg.message = message
          sugg.save!
        end
      end
    end
  end

  private

  def check_if_type_is_present
    playlist || creator || video
  end
end
