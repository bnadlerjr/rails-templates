# == Description
# The "Home" page of the application.
class HomeController < ApplicationController
  before_filter :user_required

  def index
    respond_to do |wants|
      wants.html
    end
  end
end
