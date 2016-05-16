class Api::ToursController < ApplicationController
  before_filter :authenticate_request!

  def show
    tours = Tour.all
    render json: {status: 1, tours: tours}
  end

  def join

  end

end
