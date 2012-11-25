class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sortBy = 'id'

    #Persist the sort order
    if params[:sortBy] != nil
      sortBy = params[:sortBy]
    elsif session["sortBy"]!=nil
      sortBy = session["sortBy"]
    end
    
    session["sortBy"] = sortBy

    sortString = sortBy
    @movieTitleStyle = ""
    @movieRDateStyle = ""

    if sortBy=="title"
      @movieTitleStyle="hilite"
    elsif sortBy=="release_date"
      @movieRDateStyle="hilite"
    end
    
    @all_ratings = Movie.getRatings
    @selected_ratings = nil

    #Do we have new selected ratings?
    if params[:ratings]!=nil
      @selected_ratings = params[:ratings].keys
    #Do we have persisted selected ratings?
    elsif params[:ratings]==nil and session["selected_ratings"]!=nil
      @selected_ratings = session["selected_ratings"]
    end

    # if session["selected_ratings"]!=nil
    #   @selected_ratings = session["selected_ratings"]
    # else
    #   @selected_ratings = Array.new(@all_ratings)
    # end

    # debugger
    # if params[:ratings]!=nil
    #   @selected_ratings.clear
    #   @selected_ratings = params[:ratings].keys
    # elsif session["selected_ratings"]!=nil
    #   @selected_ratings = session["selected_ratings"]
    # end
    debugger
    if not @selected_ratings==nil
      @movies = Movie.where(:rating => @selected_ratings).order(sortString)
    else
      @movies = Movie.find(:all, :order => sortString)
    end
    debugger
    session["selected_ratings"] = @selected_ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
