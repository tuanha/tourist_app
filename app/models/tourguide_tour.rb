class TourguideTour < ActiveRecord::Base
  belongs_to :tourguide
  belongs_to :tour
end
