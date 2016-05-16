class Tourguide < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :device, dependent: :destroy
  has_one :assign_device, dependent: :destroy
  has_one :device, through: :assign_device

  has_many :tourguide_tours, dependent: :destroy
  has_many :tours, through: :tourguide_tours

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: ActionController::Base.helpers.asset_path('missing.png')
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  GENDER = ['male', 'female']

  scope :not_in_tour, -> (tour_id) { where.not(id: [Tour.find(tour_id).tourguides.map(&:id)]) }

  def self.search(name)
    where("name like ? ","%#{name}%")
  end

  def update_check_password(params)
    if params[:password].blank?
      params.delete("password")
      params.delete("password_confirmation")
    end
    self.update(params)
  end

end
