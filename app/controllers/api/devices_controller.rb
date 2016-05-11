class Api::DevicesController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def show
    render json:{status: 0, message:"Not found information device code or regID code"} and return if params[:device_code].blank? or params[:regId_code].blank?

    device = Device.find_by_code(params[:device_code])

    render json:{ status: 0, message: "Device already in system" } and return unless device.present?

    if device.status == false
      #render status =002
      render json:{status: 0, message: "Device not used", details: {name_device: device.name, notification: 1}
            }
    else
      device.update(reg_id: params[:regId_code]) if device.reg_id != params[:regId_code]
      tourguide = Tourguide.where(device_id: device.id).last
      if tourguide
        render json:{
                status: 0, message: "Success", details:{
                  group: 1, name_device: device.name, notification: 2,
                  info:{
                    id: tourguide[:id],
                    name: tourguide[:name],
                    address: tourguide[:address],
                    tour_name: tourguide.tours.first.name,
                    images: tourguide.avatar.url,
                    lat: device.lat == nil ? 0 : device.lat,
                    lng: device.lng == nil ? 0 : device.lng,
                    phone: tourguide[:phone],
                    device_id: device.id
                  }
                }
              }
      else
        traveller = Traveller.where(device_id: device.id).last
        render json:{
                status:0,message: "Success", details:{
                  group: 0, name_device: device.name, notification: 2,
                  info:{
                    id: traveller[:id],
                    name: traveller[:name],
                    address: traveller[:address],
                    tour_name: traveller.tours.first.name,
                    images: traveller.avatar.url,
                    lat: device.lat == nil ? 0 : device.lat,
                    lng: device.lng == nil ? 0 : device.lng,
                    phone: traveller[:phone],
                    device_id: device.id
                  }
                }
              }
      end
    end
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
