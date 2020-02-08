class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @sort = params[:sort] || session[:sort]
    session[:ratings] = session[:ratings] || {'G'=>'','R'=>'','PG-13'=>'','PG'=>''}
    @all_ratings = Movie.all_ratings
    if session[:ratings] == {}
      session[:ratings] = @all_ratings
    end 
    @selected = params[:ratings] || session[:ratings]
    session[:sort] = @sort
    session[:ratings] = @selected
    @movies = Movie.where(rating: session[:ratings].keys).order(session[:sort])
    
    if (params[:sort].nil? and !(session[:sort].nil?)) || (params[:ratings].nil? and !(session[:ratings].nil?))
      flash.keep
      redirect_to movies_path(sort: @sort, ratings: @selected)
    end 
    
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
