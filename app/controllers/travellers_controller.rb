class TravellersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_traveller, :authenticate_user!, only: [:show, :edit, :update, :destroy]

  def index
    if params[:search_traveller_name]
      @travellers = Traveller.search(params[:search_traveller_name]).order("created_at DESC").paginate(:page => params[:page], :per_page => 30)
    else
      @travellers = Traveller.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 30)
    end
  end

  def edit
  end

  def show
  end

  def new
    @traveller = Traveller.new
  end

  def create
    @traveller = Traveller.new(traveller_params)

    respond_to do |format|
      if @traveller.save
        flash[:success] = "Traveller was successfully created."
        format.html { redirect_to @traveller }
      else
        flash[:danger] = @traveller.errors.full_messages
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @traveller.update_check_password(traveller_params)
        flash[:success] = "Traveller was successfully updated."
        format.html { redirect_to @traveller }
      else
        flash[:danger] = @traveller.errors.full_messages
        format.html { render :edit }
      end
    end
  end

  def destroy
    @traveller.destroy
    respond_to do |format|
      flash[:success] = "Traveller was successfully destroyed."
      format.html { redirect_to traveller_path }
    end
  end

  private

    def set_traveller
      @traveller = Traveller.find(params[:id]) rescue nil
      redirect_to index_travellers_path unless @traveller
    end

    def traveller_params
      params.require(:traveller).permit(:name, :address, :phone, :avatar, :gender, :email, :password, :password_confirmation)
    end

end
