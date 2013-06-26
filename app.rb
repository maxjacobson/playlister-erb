require_relative 'lib/artist'
require_relative 'lib/song'
require_relative 'lib/genre'
require 'sinatra/base'
require 'oembed' # gem install ruby-oembed
require 'youtube_search'
require 'pp'

module JukeboxSite
  class Jukebox < Sinatra::Base
    def self.parse_directory(dir_name)
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
    end
    parse_directory("data")

    # homepage
    get '/' do
      @artists = Artist.all
      @songs = Song.all
      @genres = Genre.all
      erb :home
    end

    get '/artists' do
      @artists = Artist.all
      erb :artists
    end
    get '/artist/:id' do
      @artist = Artist.all[params[:id].to_i - 1]
      @songs = Song.all
      erb :artist
    end

    get '/genres' do
      @genres = Genre.all
      erb :genres
    end
    get '/genre/:id' do
      @genre = Genre.all[params[:id].to_i - 1]
      @songs = Song.all
      erb :genre
    end

    get '/songs' do
      @songs = Song.all
      erb :songs
    end
    get '/song/new' do
      erb :new_song
    end
    post '/song/new/process' do

      # I can't get new song creation to work
      # should I create an mp3 file???
      # no errors! just doesn't work
      artist_name = params[:artist]
      song_name = params[:song]
      genre_name = params[:genre]

      artist = Artist.find_by_name(artist_name) || Artist.new.tap{|a| a.name = artist_name}
      
      song = Song.new
      song.name = song_name
      
      genre = Genre.find_by_name(genre_name) || Genre.new.tap{|g| g.name = genre_name}

      song.genre = genre
      artist.add_song(song)

      File.open("data/#{artist_name}\ -\ #{song_name}\ [#{genre_name}].mp3", "w") do |f|
        f.write "sup"
      end
      # system("touch data/#{artist_name}\ -\ #{song_name}\ [#{genre_name}].mp3")

      redirect "/songs"
    end
    get '/song/:id' do
      @songs = Song.all
      @song = Song.all[params[:id].to_i - 1]
      id = YoutubeSearch.search("#{@song.artist.name} - #{@song.name}").first["video_id"]
      url = "http://www.youtube.com/watch?v=#{id}"
      @embedcode = OEmbed::Providers::Youtube.get(url).html
      erb :song
    end


  end

end

