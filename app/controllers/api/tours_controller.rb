class Api::ToursController < ApplicationController

  def show
    tours = Tour.all
    render json: {status: 1, tours: tours}
  end

  def join

  end

end
