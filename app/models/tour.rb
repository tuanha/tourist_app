class Tour < ActiveRecord::Base
  validates :name, presence: true
  validates :information, presence: true

  has_many :traveller_tours, dependent: :destroy
  has_many :travellers, through: :traveller_tours

  has_many :tourguide_tours, dependent: :destroy
  has_many :tourguides, through: :tourguide_tours

  has_many :devices, dependent: :destroy

  def self.search(name)
    where("name LIKE ?",  "%#{name}%")
  end

  def info_tour
    {id: id, name: name, information: information, members: travellers.accepted.size}
  end
end
