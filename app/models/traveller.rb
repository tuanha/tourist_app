class Traveller < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :traveller_tours, dependent: :destroy
  has_many :tours, through: :traveller_tours

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: ActionController::Base.helpers.asset_path('missing.png')
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  GENDER = ['male', 'female']

  scope :pending, -> { joins(:traveller_tours).where('traveller_tours.status = ?', TravellerTour::STATUS[:pending]) }
  scope :cancel, -> { joins(:traveller_tours).where('traveller_tours.status = ?', TravellerTour::STATUS[:cancel]) }
  scope :accepted, -> { joins(:traveller_tours).where('traveller_tours.status = ?', TravellerTour::STATUS[:accepted]) }

  def self.search(name)
    where("name like ? ", name)
  end

  def update_check_password(params)
    if params[:password].blank?
      params.delete("password")
      params.delete("password_confirmation")
    end
    self.update(params)
  end
end
