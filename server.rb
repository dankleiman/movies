require 'sinatra'
require 'csv'
require 'pry'

def get_movies
  movies = []
  CSV.foreach('public/movies.csv', headers: true, header_converters: :symbol) do |movie|
      movies << movie.to_hash
  end
  movies.sort_by!{ |movie| movie[:title]}
  movies
end

def get_single_movie(id, movie_list)
  single_movie = {}
  movie_list.each do |movie|
   if id == movie[:id]
     single_movie = movie
   end
  end
  single_movie
end


get '/' do
  erb :index
end

get '/movies' do

  page = params[:page].to_i
  big_list = get_movies
  if big_list.length % 20 == 0
    @max_length = (big_list.length/20)
  else
    @max_length = ((big_list.length/20) + 1)
  end
  if params[:page] == nil
    page = 1
  end
  @movies = big_list[(20*(page-1))..(20*(page-1)+19)]

  erb :movies
end

get '/movies/:movie_id' do
  @movie_id = params[:movie_id]
  @movie_data = get_single_movie(@movie_id, get_movies)
  erb :show
end
