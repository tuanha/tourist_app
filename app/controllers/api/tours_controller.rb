class Api::ToursController < ApplicationController
  # before_filter :authenticate_request!
  skip_before_filter  :verify_authenticity_token

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

  def feedbacks
    render json: { status: 0, message: "Missing device code."} and return if params[:code].blank?

    device = Device.find_by_code(params[:code])
    render json: {status: 0, message: "Device not already in system"} and return unless device.present?

    traveller = device.traveller 
    render json: {status: 0, message: "You have no right to send feedback"} and return unless  traveller.present?

    feedbacks = traveller.feedbacks.new(comment: params[:comment], rating: params[:rating])

    if feedbacks.save
      render json: { status: 1, message: "Success"}
    else
      render json: { status: 0, message: "Can't send feedback"}
    end

  end

  def search

    tour = Tour.search(params[:name])
    tour_all = Tour.find_by_name(params[:name])
    tour.each_with_index do |t,i|
    # byebug
    if tour
      render  json: {
        status: 1, message: "Success",
        result: {
          id: t.id ,
          name: t.name,
          members: tour_all.travellers.includes(:traveller_tours).select(:traveller_id).count,
        }
      }
    else
      render json: {status: 1, message: "Not success"}
    end

    end
  end

end
