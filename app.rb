Artist.reset_artists
Genre.reset_genres
Song.reset_songs

songs = Dir.entries("data").delete_if{|str| str == "." || str == ".."}

songs.each do |filename|

  artist_name = filename.split(" - ")[0]
  song_name = filename.split(" - ")[1].split("[")[0].strip
  genre_name = filename.split(" - ")[1].split(/\[|\]/)[1]

  artist = Artist.find_by_name(artist_name) || Artist.new
  artist.name = artist_name
  
  song = Song.new
  song.name = song_name
  
  genre = Genre.find_by_name(genre_name) || Genre.new
  genre.name = genre_name

  song.genre = genre
  artist.add_song(song)

end

loop do
  puts "Name an artist?"
  choice = gets.chomp
  p Artist.all.select{|artist| artist.name == choice }[0].songs.collect{|song| song.name}
end

# binding.pry