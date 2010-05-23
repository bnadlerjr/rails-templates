# == Description
# Email notifier so that users can reset their password.
class Notifier < ActionMailer::Base  
  # TODO: Supply host name and email address 
  default_url_options[:host] = "example.com"  

  # Creates email with instructions for resetting password.
  def password_reset_instructions(user)  
    subject       "Password Reset Instructions"  
    from          "app@example.com"  
    recipients    user.email  
    sent_on       Time.now  
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
  end  
end
