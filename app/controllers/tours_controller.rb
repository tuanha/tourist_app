class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    if params[:search_tour_name]
      @tours = Tour.search(params[:search_tour_name]).order("created_at DESC").paginate(:page => params[:page], :per_page => 30)
    else
      @tours = Tour.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 30)
    end
  end

  def show
    @travellers_pending = @tour.travellers.pending
    @travellers_accept = @tour.travellers.accept
  end

  def new
    @tour = Tour.new
  end

  def edit
  end

  def create
    @tour = Tour.new(tour_params)

    respond_to do |format|
      if @tour.save
        flash[:success] = "Tour was successfully created."
        format.html { redirect_to @tour }
      else
        flash[:danger] = @tour.errors.full_messages
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @tour.update(tour_params)
        flash[:success] = "Tour was successfully updated."
        format.html { redirect_to @tour }
      else
        flash[:danger] = @tour.errors.full_messages
        format.html { render :edit }
      end
    end
  end

  def destroy
    @tour.destroy
    respond_to do |format|
      flash[:success] = "Tour was successfully destroyed."
      format.html { redirect_to tours_url }
    end
  end


  private

    def set_tour
      @tour = Tour.find(params[:id])
    end

    def tour_params
      params.require(:tour).permit(:name, :information)
    end
end
