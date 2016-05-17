class Api::ToursController < ApplicationController
  # before_filter :authenticate_request!

  def show
    tours = Tour.all
    render json: {status: 1, tours: tours}
  end

  def join

  end

  def users_list
  	render json: {status: 0, message: "Missing device code."} and return if params[:code].blank?

  	device = Device.find_by_code(params[:code])
    	render json: {status: 0, message: "Device not already in system"} and return unless device.present?
    	# byebug
    	user = device.user
    	render json: {status: 0, message: "Device not used"} and return unless user.present?    	
    	render json: {
    		status: 1, message: "Success",
    		device: {
    			name: device.name
    		},
    		user: {
    			name: user.name,
    			address: user.address,
    			tour_name: device.tour.name,
    			avatar: user.avatar.url,
    			lat: device.lat == nil ? 0 : device.lat,
                 lng: device.lng == nil ? 0 : device.lng,
                 phone: user[:phone],
    		}
    	}
  end

end
