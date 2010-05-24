# == Description
# Methods added to this helper will be available to all templates in the 
# application.
module ApplicationHelper

  # Block method that creates an area of the view that is only rendered if the
  # request is coming from an anonymous user.
  def anonymous_only(&block)
    block.call if !logged_in?
  end
  
  # Block method that creates an area of the view that only renders if the 
  # request is coming from an authenticated user.
  def authenticated_only(&block)
    block.call if logged_in?
  end
  
  # Block method that creates an area of the view that only renders if the 
  # request is coming from an administrative user.
  def admin_only(&block)
    block.call if admin_logged_in?
  end

  # Renders the flash
  def render_flash
    unless flash.nil? || flash.empty?
      content_tag(:div, :id => 'flash') do
        flash.each do |key, msg|
          content_tag(:p, msg, :class => key)
        end
      end
    end
  end

  # Custom formatting of model errors.
  def errors_for(object)
    return if 0 == object.errors.count
    errors = object.errors.full_messages
    if errors.is_a?(Array)
      text = "There were some errors when trying to save:"
    else
      errors = [errors]
      text = "There was an error when trying to save:"
    end
    content_tag(:div, :class => 'error') do
      content_tag(:p, text) + 
      content_tag(:ol, errors.map { |msg| content_tag(:li, msg) }, 
                  :class => 'disc')
    end
  end
end
