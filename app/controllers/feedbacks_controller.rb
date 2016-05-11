class FeedbacksController < ApplicationController
  before_action :authenticate_user!

  def index
    @feedbacks = Feedback.all.paginate(:page => params[:page], :per_page => 30)
  end
end
