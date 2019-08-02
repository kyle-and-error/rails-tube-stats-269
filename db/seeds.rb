watched_videos = WatchedVideo.all
watched_videos.each do |watched_video|
  random = (1..14).to_a.sample
  watched_video.datetime_watched = watched_video.datetime_watched - random.days
  watched_video.save!
end
