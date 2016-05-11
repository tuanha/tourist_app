class Device < ActiveRecord::Base
  has_one :assign_device, dependent: :destroy
  has_one :traveller, through: :assign_device
  has_one :tourguide, through: :assign_device

  def availabe?
    !(traveller || tourguide)
  end

  def self.availabe
    Device.select{ |device| device.availabe? }
  end
end
