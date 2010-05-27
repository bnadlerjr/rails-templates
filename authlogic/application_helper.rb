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
      messages = []
      flash.each do |key, msg|
        messages << "<p class=\"#{key}\">#{msg}</p>"
      end

      content_tag(:div, messages, :id => 'flash')
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

  # Wrapper for standard link_to method that adds a 'current' CSS class to 
  # the link if it is the current page
  def menu_link_to(name, options={}, html_options={})
    html_options.merge!({ :class => 'current' }) if current_page?(options)
    link_to(name, options, html_options)
  end
end
