# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Cleaning up database..."
User.destroy_all
YoutubeAccount.destroy_all
Creator.destroy_all
Playlist.destroy_all
Video.destroy_all


puts "Generating users..."

kyle = User.new({
    email: 'kylescho99@gmail.com',
    password: '111111',
    first_name: 'Kyle',
    last_name: 'Cho',
    avatar:'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Kampfar_Rockharz_2016_08.jpg/220px-Kampfar_Rockharz_2016_08.jpg'
  })

kyle.save!

thomas = User.new({
    email: 'berhane097@gmail.com',
    password: '111111',
    first_name: 'Thomas',
    last_name: 'Berhane',
    avatar:'https://static1.squarespace.com/static/54f76245e4b08e5a08a87ec8/t/5b1e906b575d1f0e16e80939/1528729713813/Frida+2.jpg?format=750w'
  })

thomas.save!


# kyle_yt_account = YoutubeAccount.new({
#   email: 'kyleschoo99@gmail.com',
#   youtube_id: 'UCS5fST35wgiwfFkGy07EtBw',
#   user: kyle,
# })

# kyle_yt_account.save!

thomas_yt_account = YoutubeAccount.new({
  email: 'berhane097@gmail.com',
  youtube_id: 'UCIgX5OjK65AaJDni5ToK89w',
  user: thomas,
})

thomas_yt_account.save!
#------------------------------------------------------------------
#------------------------------------------------------------------

puts "generating creators"

# grm_daily = Creator.new({
#   youtube_id: "https://www.youtube.com/user/GRIMEDAILYMEDIA"
# })

# grm_daily.save!

abc_anime = Creator.new({
  youtube_id: "UC_z2mdJATu6ofo-wOznVXdQ"
})

abc_anime.save!

msvogue23 = Creator.new({
  youtube_id: "UCstaTFTqZAC_OqfAq_JF6vA"
})

msvogue23.save!
#------------------------------------------------------------------
#------------------------------------------------------------------

puts "generating playlist..."

# uk_drill_music = Playlist.new({
#   title: "uk_drill_music",
#   youtube_id: "PLaCPeFCSsrrHjNG1wFSY3magxkS54iZjA",
#   creator: grm_daily

# })

# uk_drill_music.save!

# MORE SEEDS FOR PLAYLIST

# gym_music = Playlist.new({
# title: "gym_music",
# youtube_id: "PLChOO_ZAB22WAvnFw86vUueyv026ULwIv"
#})

# gym_music.save!

#sleep_music = Playlist.new({
# title: "sleep_music",
# youtube_id: "PLhn6RI-s94ua7APvcNyGkV_OTn7hNZVAE"
#})

# sleep_music.save!

# END OF MORE SEEDS FOR PLAYLIST

# battle_rap = Playlist.new({
#   title: "battle_rap",
#   youtube_id: "PLtWLnQHvxck1c2HRc-ekXjHYMxwqludVs",
#   creator: grm_daily
# })

# battle_rap.save!

techno_music = Playlist.new({
  title: "techno_music",
  youtube_id: "PLriDNoSeceaR08rkPw6TzDnSANN7j4KN7",
  creator: abc_anime
})

techno_music.save!

ruby_on_rails_tutorial = Playlist.new({
  title: "ruby on rails tutorial",
  youtube_id: "PLDmvslp_VR0xlwr5lAx2PDsZLu7oIOhpX",
  creator: msvogue23
})

ruby_on_rails_tutorial.save!
#------------------------------------------------------------------
#------------------------------------------------------------------

puts "generating videos ..."

kakashi_vs_obito = Video.new({
  title: "kakashi vs obito",
  youtube_id: "TmGD7P3uI4M",
  topic: "anime",
  creator: abc_anime
})

kakashi_vs_obito.save!

# dave_chappelle = Video.new({
#   title: "dave chappelle",
#   youtube_id: "ZjsufO9hZwo&t=2s",
#   topic: "comedy",
#   creator: grm_daily
# })

# dave_chappelle.save!

eminem = Video.new({
  title: "eminem",
  youtube_id: "_Yhyp-_hX2s",
  topic: "hip-hop",
  creator: msvogue23
})

eminem.save!

#------------------------------------------------------------------
#------------------------------------------------------------------



puts "Finished!"

