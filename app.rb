require_relative 'lib/artist'
require_relative 'lib/song'
require_relative 'lib/genre'
require 'pry'
require 'pp'
require 'awesome_print'

class Jukebox
  attr_accessor :on
  def initialize(mp3_directory)
    Artist.reset_artists
    Genre.reset_genres
    Song.reset_songs
    parse_directory(mp3_directory)
    # start
  end

  def parse_directory(dir_name)
    songs = Dir.entries(dir_name).delete_if{|str| str[0] == "."}
    songs.each do |filename|
      artist_name = filename.split(" - ")[0]
      song_name = filename.split(" - ")[1].split("[")[0].strip
      genre_name = filename.split(" - ")[1].split(/\[|\]/)[1]

      artist = Artist.find_by_name(artist_name) || Artist.new.tap{|a| a.name = artist_name}
      
      song = Song.new
      song.name = song_name
      
      genre = Genre.find_by_name(genre_name) || Genre.new.tap{|g| g.name = genre_name}

      song.genre = genre
      artist.add_song(song)
    end
    # ap Artist.all
  end

  def help(msg = "")
    puts msg unless msg.empty?
    puts "help text"
  end

  # def start
  #   # # p Artist.all.collect{|a| a.name}
  #   # # pp Artist.all
  #   # puts "game loop starts here!"
  #   # puts Artist.all.collect{|artist| artist.name}
  # end

end

# Jukebox.new("data")

