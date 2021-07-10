require 'rubygems'
require 'gosu'
require './input_functions.rb'

Xposition = 140
Yposition = 485
TOP_COLOR = Gosu::Color.new(0xff_ffffff)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)
U_BOTTOM =  Gosu::Color::GREEN

module ZOrder
  BACKGROUND,PLAYER, UI = *0..2
end


module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Album
    attr_accessor :artist, :title, :genre, :tracks

    def initialize (artist, title, genre, tracks)
        @artist = artist
        @title = title
        @genre = genre
        @tracks = tracks
    end
end

class Track
  attr_accessor :name, :location

  def initialize(name, location)

     @name = name
     @location = location
   end
 end

 def read_tracks(music_file,count)

   tracks_array = Array.new()
     i = 0
     while i < count
     track = read_track(music_file)
     tracks_array << track# << adds a new value in the array
         i += 1
         #puts (tracks_array)
     end

   return tracks_array
 end

 # reads in a single track from the given file.
 def read_track(a_file)
     track_name = a_file.gets.chomp
     track_location = a_file.gets.chomp
     returning_track = Track.new(track_name, track_location)
     return returning_track
 end

 def print_tracks(tracks)
     i = 0
     while i < tracks.length
         print_track(tracks[i])
         i += 1
     end
 end

 # Takes a single track and prints it to the terminal
 def print_track(track)
   puts('Track title is: ' + track.name)
     puts('Track file location is: ' + track.location)
 end

 def print_album(albums,id)
    #puts "some"
   # print out all the albums fields/attributes except tracks
   	puts("ALBUM ID: " + id.to_s.chomp)
     puts(albums.title + " by " + albums.artist)
 	puts('Genre is ' + $genre_names[albums.genre] )

 end
 def print_albums(albums)
 	option = read_integer_in_range("1 - Display all \n2 - Display genre",1,2)
 	if option == 1 then
 	  i = 0
     #puts"for1"
 	  while i < albums.length
       #puts"loop1"
 		print_album(albums[i],i+1)
 		i += 1
 	  end
 	elsif option == 2 then
 		genre = read_integer_in_range("Select Genre \n1 - Pop\n2 - Classic\n3 - Jazz\n4 - Rock ",1,4)
 		i = 0
 		while i < albums.length
 			if albums[i].genre == genre
         #puts albums[i].genre
 				print_album(albums[i],i+1)
 			end
 			i = i + 1
 		end
 	end

 end

 def play_existing_album(albums)
 	length = albums.length
 	album_index = read_integer_in_range("Enter album ID:",1,length) - 1
 	album = albums[album_index]
 	print_tracks(album.tracks)
     track_id = play_selected_track(album)
     #puts track_id
     return album_index, track_id, album
 end

 def play_selected_track(album)
 	length = album.tracks.length
 	i = read_integer_in_range("enter track number: ",1,length)
 	puts("Playing track " + album.tracks[i-1].name.chomp + " from album " + album.title.chomp)
 	#sleep(15)
  return i-1
 end

 def read_album(a_file)


   album_title = a_file.gets()
   #puts (album_title)
   album_artist = a_file.gets()
   #puts (album_artist)
   album_genre = a_file.gets.to_i()
   #puts (album_genre)
   track_count = a_file.gets.to_i()
   #puts (track_count)
   @album = Album.new(album_artist,album_title,album_genre,track_count)
   if track_count <= 15 then
   tracks = read_tracks(a_file,track_count)
    @album.artist = album_artist
    @album.title = album_title
    @album.genre = album_genre
    #puts album.genre
    @album.tracks = tracks
    Album.new(@album.artist,@album.title,@album.genre,@album.tracks)
     return @album
   else
     puts ('Please select again a file with albums which have less than 15 tracks each.')
   end
 end

 def read_in_albums()
   #puts"hello"
   albums = Array.new
   begin
     file_name = read_string("Enter which text file you want to load: ")
     a_file = File.new(file_name, "r")
   rescue Errno::ENONET => e
 end

 i = 0
 if a_file.nil? then
   puts("File does not exist. Please enter again")
   file_readed = -1
 else
   album_count = a_file.gets().to_i
   #print album_count
   while i < album_count do
     albums << read_album(a_file)
     i += 1
   end
   file_readed = 1
   #puts albums
   #puts file_readed
   #puts albums.length
   puts"File readed successfully"
   a_file.close()
   return albums,file_readed
 end
 end

class ArtWork
	attr_accessor :bmp

	def initialize (file)
		@bmp = Gosu::Image.new(file)
	end
end

# Put your record definitions here

class MusicPlayerMain < Gosu::Window

	def initialize
	    super 600, 800, false
	    self.caption = "Music Player"
      @background = BOTTOM_COLOR
      @u_background = U_BOTTOM
      @player = TOP_COLOR
      @track_font = Gosu::Font.new(20)
      #track_id, album = play_existing_album(albums)
      @file_readed = 0
      @albums = Array.new
		# Reads in an array of albums from a file and then prints all the albums in the
		# array to the terminal
    while @file_readed != 1 do
      @albums,@file_readed = read_in_albums()
    end
       print_albums(@albums)

      #@album = Album.new(title,artist,genre,tracks)
      i = 0
      @tracks = Array.new
      @album_id, @present_track, @album = play_existing_album(@albums)
      while i < @albums.length do
        @tracks << @albums[i].tracks
        i += 1
      end
      #puts"enter location: "
      #@location = gets.chomp()
      @location = @album.tracks[@present_track].location.chomp
      @song = Gosu::Song.new(@location)
      @song.play(false)
      @song.volume = 0.5
    end

  # Put in your code here to load albums and tracks

  # Draws the artwork on the screen for all the albums

  def draw_albums ()
    # complete this code
    #@album_id = gets.chomp
    #@album_image = ArtWork.new("images/NeilDiamondHits.bmp")
    #case @album_id
    #when 1
    case @album_id
    when 0
      @album_image = ArtWork.new("images/NeilDiamondHits.bmp")
    when 1
      @album_image = ArtWork.new("images/artwork.bmp")
    when 2
      @album_image = ArtWork.new("images/abeautifullie.bmp")
    when 3
      @album_image = ArtWork.new("images/everything.bmp")
    end
      @album_image.bmp.draw(175,150,2,ZOrder::PLAYER)
  #end
end

  def draw_buttons()
    @music_buttons = ArtWork.new("media/play_buttons.bmp")
    @music_buttons.bmp.draw(45,550,3)
  end
  # Detects if a 'mouse sensitive' area has been clicked on
  # i.e either an album or a track. returns true or false

  def area_clicked(mouse_x,mouse_y)
     # complete this code
     if (mouse_y < 642 && mouse_y> 545) then
       if (mouse_x < 548 && mouse_x > 454) then
          return 5
       elsif (mouse_x <445 && mouse_x > 353) then
          return 4
       elsif (mouse_x < 342 && mouse_x > 250) then
          return 3
       elsif (mouse_x < 241 && mouse_x > 148) then
          return 2
       elsif (mouse_x < 138 && mouse_x > 42) then
          return 1
       end
     end
  end


  # Takes a String title and an Integer ypos
  # You may want to use the following:
  def display_track(title)
  	@track_font.draw(title, Xposition, Yposition, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
  end


  # Takes a track index and an Album and plays the Track from the Album

  def playTrack(track, album)
  	 # complete the missing code
  			@song = Gosu::Song.new(album.tracks[track].location)
  			@song.play(false)
    # Uncomment the following and indent correctly:
  	#	end
  	# end
  end

# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR

	def draw_background
    Gosu.draw_rect(0, 0, 600, 800, @background, ZOrder::BACKGROUND, mode=:default)
    Gosu.draw_rect(40, 40, 510, 710, @player, ZOrder::PLAYER, mode=:default)
    #Gosu.draw_rect(40, 370, 200, 700, @u_background, ZOrder::U_BACKGROUND, mode=:default)
    display_track(@album.tracks[@present_track].name.chomp+ " from album " + @album.title)
    draw_albums()
    draw_buttons()
	end

# Not used? Everything depends on mouse actions.

	def update
	end

 # Draws the album images and the track list for the selected album

	def draw
		# Complete the missing code
		draw_background()
	end

 	def needs_cursor?; true;
  end

	# If the button area (rectangle) has been clicked on change the background color
	# also store the mouse_x and mouse_y attributes that we 'inherit' from Gosu
	# you will learn about inheritance in the OOP unit - for now just accept that
	# these are available and filled with the latest x and y locations of the mouse click.

	def button_down(id)

    case id
        #calling area_clicked for detecting a click on a button
    when Gosu::MsLeft
        button = area_clicked(mouse_x,mouse_y)
        case button
        when 1
          @song.pause
        when 2
          @song.stop
        when 3
          @song.play(true)
        when 4
            if @present_track < @album.tracks.length-1 then
                @present_track += 1
                @location = @album.tracks[@present_track].location.chomp
                @song = Gosu::Song.new(@location)
                @song.play
            else
                puts("This was the last album track")
                if @album_id < @albums.length-1 then
                  @album_id += 1
                else
                  @album_id = 0
                end
                @present_track = 0
                @album = @albums[@album_id]
                @location = @album.tracks[@present_track].location.chomp
                @song = Gosu::Song.new(@location)
                @song.play
            end
        when 5
            if @present_track > 0 then
                @present_track -= 1
                @location = @album.tracks[@present_track].location.chomp
                @song = Gosu::Song.new(@location)
                @song.play

            else
                puts("This was the first album track")
              if @album_id > 0 then
                @album_id -= 1
              else
                @album_id = 3
              end
                @album = @albums[@album_id]
                @present_track = @album.tracks.length-1
                @location = @album.tracks[@present_track].location.chomp
                @song = Gosu::Song.new(@location)
                @song.play

            end
          end
	    end
	end

end

#def main()

  #file_readed = -1

		#albums,file_has_loaded = read_in_albums()


	#if ( file_has_loaded != 1 )then
	 # puts("File does not exist!")
	#else
    #print_albums(albums)
    #track_id, album = play_existing_album(albums)
  #end

#end

#main()
	#search_name = read_string("Enter the track name you wish to find: ")
	#search_for_track_name(album.tracks, search_name)



# Show is a method that loops through update and draw

MusicPlayerMain.new.show if __FILE__ == $0
