class Api::DevicesController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def show
    render json:{status: 0, message:"Not found information device code or regID code"} and return if params[:code].blank? or params[:regId_code].blank?

    device = Device.find_by_code(params[:code])

    render json:{ status: 0, message: "Device not already in system" } and return unless device.present?

    user = device.user

    render json:{status: 0, message: "Device not used", details: {name_device: device.name, notification: 1}} unless user
    device.update(reg_id: params[:regId_code]) if device.reg_id != params[:regId_code]

    render json:{
                status: 1, message: "Success",
                  device: {
                    id: device.id,
                    name: device.name,
                  },
                  user: {
                    id: user.id,
                    type: user.class.name,
                    name: user.name,
                    address: user.address,
                    images: user.avatar.url,
                    lat: device.lat == nil ? 0 : device.lat,
                    lng: device.lng == nil ? 0 : device.lng,
                    phone: user[:phone],
                    tour_name: device.tour.name,
                  }
              }
  end

  def create
    render json: {status: 0, message:"Not found information Device."} and return if params[:code].blank?

    device = Device.find_by_code(params[:code])
    render json: {status: 0, message: "Device code already exist"} and return if device.present?

    new_device = Device.new(name: params[:code], code: params[:code])

    if new_device.save
      render json: {status: 1, message: "Success"}
    else
      render json: {status: 0, message: new_device.errors.full_messages}
    end
  end

end
