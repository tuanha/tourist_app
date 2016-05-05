class TravellerTour < ActiveRecord::Base
  belongs_to :traveller
  belongs_to :tour

  STATUS={pending: 'pending', cancel: 'cancel', accept: 'accept'}

end
