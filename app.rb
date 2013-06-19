class Jukebox
  attr_accessor :on
  def initialize(mp3_directory)
    parse_directory(mp3_directory)
  end

  def parse_directory(dir_name)
    songs = Dir.entries(dir_name).delete_if{|str| str == "." || str == ".."}
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
  end

  def help(msg = "")
    puts msg unless msg.empty?
    puts "Available commands: 'artists', 'genres', 'songs', 'songs by artist', 'songs by genre', '[genre name] songs', 'songs by [artist name]', 'who made [song name]', 'help', 'exit'"
  end

  def songs_by_artist(choice)
    if Artist.all.any? {|artist| artist.name.downcase == choice.downcase }
      p Artist.all.select{|artist| artist.name.downcase == choice.downcase }[0].songs.collect{|song| song.name}
    else
      puts "No artist by that name"
    end
  end

  def songs_by_genre(choice)
    if Genre.all.any? {|genre| genre.name.downcase == choice.downcase}
      p Genre.all.select{|genre| genre.name == choice.downcase}[0].songs.collect{|song| song.name}
    else
      puts "No genre by that name"
    end
  end

  def who_made(choice)
    if Song.all.any? {|song| song.name.downcase == choice.downcase }
      puts Song.all.select{|song| song.name.downcase == choice.downcase }[0].artist.name
    else
      puts "No song by that name"
    end
  end

  def start
    @on = true
    help("\n### Welcome to Jukebox ###\n")
    

    while on?
      puts "Type a command"
      print "> "
      command = gets.chomp.downcase
      case command
      when "artists"
        p Artist.all.collect{|artist| artist.name}
      when "genres"
        p Genre.all.collect{|genre| genre.name}
      when "songs"
        p Song.all.collect{|song| song.name}
      when "songs by artist"
        puts "Which artist?"
        print ">> "
        choice = gets.chomp
        songs_by_artist(choice)
      when "songs by genre"
        puts "Which genre?"
        print ">> "
        choice = gets.chomp
        songs_by_genre(choice)
      when /([^ ]+) songs/
        choice = command.split("songs")[0].strip
        songs_by_genre(choice)
      when /songs by (.+)/
        choice = command.split("songs by ")[1].strip
        songs_by_artist(choice)
      when /who made (.+)/
        choice = command.split("who made ")[1].strip
        who_made(choice)
      when "exit"
        @on = false
      else
        help()
      end
    end
  end

  def on?
    @on
  end
end

Artist.reset_artists
Genre.reset_genres
Song.reset_songs

jb = Jukebox.new("data")
jb.start