class ToursController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tour, only: [:show, :edit, :update, :destroy, :select_tourguide, :cancel_tourguide, :action_traveller, :set_device, :remove_device]

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
    @tourguides = Tourguide.not_in_tour(@tour.id)
    @tourguides_of_tour = @tour.tourguides
    @device_availabes = Device.availabe
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
    tourguide_tour = @tour.tourguide_tours.new(tourguide_id: params[:tourguide_id])

    if tourguide_tour.save
      flash[:success] = "Tourguide was successfully selected."
    else
      flash[:danger] = "Select tourguide failure"
    end

    render json: {}
  end

  def cancel_tourguide
    tourguide_tour = @tour.tourguide_tours.where(tourguide_id: params[:tourguide_id]).first

    if tourguide_tour.delete
      flash[:success] = "Tourguide was successfully cancel."
    else
      flash[:danger] = "Cancel tourguide failure"
    end
    render json: {}
  end

  def action_traveller
    traveller_tour = @tour.traveller_tours.where(traveller_id: params[:traveller_id]).first
    traveller_tour.update(status: params[:status])
    travellers_pending = @tour.travellers.pending
    @travellers_accepted = @tour.travellers.accepted
    @device_availabes = Device.availabe

    respond_to do |format|
      format.js do
        @return_content_accepted = render_to_string(partial: 'tours/travellers_accepted', locals: { tour: @tour, travellers_accepted: @travellers_accepted })
        @return_content_pending = render_to_string(partial: 'tours/travellers_pending', locals: { tour: @tour, travellers_pending: travellers_pending })
      end
    end
  end

  def remove_device
    device = Device.find(params[:device_id])
    if AssignDevice.find_by_device_id(params[:device_id]).destroy
      device.update(tour_id: nil)
      flash[:success] = "Remove device was successfully."
    else
      flash[:danger] = "Remove device failure"
    end
    render json: {}
  end

  def set_device
    device = Device.find(params[:device_id])
    params_assign = {device_id: params[:device_id]}
    params[:type] == 'Tourguide' ? params_assign.merge!(tourguide_id: params[:user_id]) : params_assign.merge!(traveller_id: params[:user_id])
    assign_device = AssignDevice.new(params_assign)

    if assign_device.save
      device.update(tour_id: @tour.id)
      flash[:success] = "Set device for #{params[:type]} was successfully."
    else
      flash[:danger] = assign_device.errors.full_messages
    end
    render json: {}
  end

  private

    def set_tour
      @tour = Tour.find(params[:id])
    end

    def tour_params
      params.require(:tour).permit(:name, :information)
    end
end
