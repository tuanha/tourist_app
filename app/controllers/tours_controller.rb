class ToursController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tour, only: [:show, :edit, :update, :destroy, :select_tourguide, :action_traveller]

  def index
    if params[:search_tour_name]
      @tours = Tour.search(params[:search_tour_name]).order("created_at DESC").paginate(:page => params[:page], :per_page => 30)
    else
      @tours = Tour.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 30)
    end
  end

  def show
    @travellers_pending = @tour.travellers.pending
    @travellers_accepted = @tour.travellers.accepted
    @tourguides = Tourguide.not_tour
    @tourguides_of_tour = @tour.tourguides
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

  def select_tourguide
    tourguide = Tourguide.find(params[:tourguide_id])
    if tourguide.update(tour_id: params[:id])
      flash[:success] = "Tourguide was successfully selected."
    else
      flash[:danger] = "Select tourguide was error"
    end
    render json: {}
  end

  def cancel_tourguide
    tourguide = Tourguide.find(params[:tourguide_id])
    if tourguide.update(tour_id: nil)
      flash[:success] = "Tourguide was successfully cancel."
    else
      flash[:danger] = "Cancel tourguide was error"
    end
    render json: {}
  end

  def action_traveller
    traveller_tour = @tour.traveller_tours.where(traveller_id: params[:traveller_id]).first
    traveller_tour.update(status: params[:status])
    travellers_pending = @tour.travellers.pending
    @travellers_accepted = @tour.travellers.accepted

    respond_to do |format|
      format.js do
        @return_content_accepted = render_to_string(partial: 'tours/travellers_accepted', locals: { tour: @tour, travellers_accepted: @travellers_accepted })
        @return_content_pending = render_to_string(partial: 'tours/travellers_pending', locals: { tour: @tour, travellers_pending: travellers_pending })
      end
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
