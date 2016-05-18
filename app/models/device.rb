class Device < ActiveRecord::Base
  has_one :assign_device, dependent: :destroy
  has_one :traveller, through: :assign_device
  has_one :tourguide, through: :assign_device

  belongs_to :tour

  scope :availabe, -> { where tour_id: nil }

  def availabe?
    !tour.present?
  end

  def user
    traveller || tourguide
  end

end
