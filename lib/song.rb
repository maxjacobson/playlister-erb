class Song
  
  attr_accessor :genre, :name, :artist
  All = []

  def initialize
    All << self
  end

  def embedcode
    id = YoutubeSearch.search("#{@artist.name} - #{@name}").first["video_id"]
    url = "http://www.youtube.com/watch?v=#{id}"
    OEmbed::Providers::Youtube.get(url).html
  end

  def self.all
    All
  end

  def self.reset_songs
    All.clear
  end

end