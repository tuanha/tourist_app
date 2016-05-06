class Tour < ActiveRecord::Base
  validates :name, presence: true
  validates :information, presence: true

  has_many :traveller_tours, dependent: :destroy
  has_many :travellers, through: :traveller_tours

  has_many :tourguides, dependent: :destroy

  def self.search(name)
    where("name like ?", name)
  end

end
