# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Block method that creates an area of the view that is only rendered if the request 
  # is coming from an anonymous user.
  def anonymous_only(&block)
    block.call if !logged_in?
  end
  
  # Block method that creates an area of the view that only renders if the request is 
  # coming from an authenticated user.
  def authenticated_only(&block)
    block.call if logged_in?
  end
  
  # Block method that creates an area of the view that only renders if the request 
  # is coming from an administrative user.
  def admin_only(&block)
    block.call if admin_logged_in?
  end
end