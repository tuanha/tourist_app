class TourguidesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tourguide, :authenticate_user!, only: [:show, :edit, :update, :destroy]

  def index
    if params[:search_tourguide_name]
      @tourguides = Tourguide.search(params[:search_tourguide_name]).order("created_at DESC").paginate(:page => params[:page], :per_page => 30)
    else
      @tourguides = Tourguide.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 30)
    end
  end

  def edit
  end

  def show
  end

  def new
    @tourguide = Tourguide.new
  end

  def create
    @tourguide = Tourguide.new(tourguide_params)

    respond_to do |format|
      if @tourguide.save
        flash[:success] = "tourguide was successfully created."
        format.html { redirect_to @tourguide }
      else
        flash[:danger] = @tourguide.errors.full_messages
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @tourguide.update_check_password(tourguide_params)
        flash[:success] = "tourguide was successfully updated."
        format.html { redirect_to @tourguide }
      else
        if @tourguide.errors.any?
          flash[:danger] = @tourguide.errors.full_messages
        end
        format.html { render :edit }
      end
    end
  end

  def destroy
    @tourguide.destroy
    respond_to do |format|
      flash[:success] = "tourguide was successfully destroyed."
      format.html { redirect_to tourguide_path }
    end
  end

  private

    def set_tourguide
      @tourguide = Tourguide.find(params[:id]) rescue nil
      redirect_to index_tourguides_path unless @tourguide
    end

    def tourguide_params
      params.require(:tourguide).permit(:name, :address, :phone, :avatar, :gender, :email, :password, :password_confirmation)
    end

end
