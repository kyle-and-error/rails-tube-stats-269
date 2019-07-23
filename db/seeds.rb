# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Cleaning up database..."
User.destroy_all
puts "Generating users..."

kyle = User.new({
    email: 'kyleschoo99@gmail.com',
    password: 'test_password',
    first_name: 'Kyle',
    last_name: 'Cho',
    avatar:'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Kampfar_Rockharz_2016_08.jpg/220px-Kampfar_Rockharz_2016_08.jpg'
  })

kyle.save

thomas = User.new({
    email: 'berhane097@gmail.com',
    password: 'test_password',
    first_name: 'Thomas',
    last_name: 'Berhane',
    avatar:'https://static1.squarespace.com/static/54f76245e4b08e5a08a87ec8/t/5b1e906b575d1f0e16e80939/1528729713813/Frida+2.jpg?format=750w'
  })

thomas.save


kyle_yt_account = YoutubeAccount.new({
  email: 'kyleschoo99@gmail.com',
  url: 'https://www.youtube.com/channel/UCS5fST35wgiwfFkGy07EtBw',
  user: kyle,
})

thomas_yt_account = YoutubeAccount.new({
  email: 'berhane097@gmail.com',
  url: 'https://www.youtube.com/channel/UCIgX5OjK65AaJDni5ToK89w',
  user: thomas
})


