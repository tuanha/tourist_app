class DevicesController < ApplicationController
  before_action :authenticate_user!

  def index
    @devices = Device.all.paginate(:page => params[:page], :per_page => 30)
  end

  def show
    @device = Device.find(params[:id])
  end

  def destroy
    device = Device.find(params[:id])
    respond_to do |format|
      if device.destroy
        format.html { redirect_to devices_path, success: 'Device was successfully deleted.' }
      else
        format.html { redirect_to devices_path, error: 'Delete device failure' }
      end
    end
  end
end
