class AssignDevice < ActiveRecord::Base
  belongs_to :device
  belongs_to :traveller
  belongs_to :tourguide

  validates_uniqueness_of :device_id
  validate :availabe_to_use

  def availabe_to_use
    errors.add(:devices, 'can only be used by a user') if traveller_id.present? && tourguide_id.present?
  end

end
