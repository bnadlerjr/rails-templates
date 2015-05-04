@commands.pre_bundle do
  gem "letter_opener", "~> 1.3.0", group: :development
  insert_into_file "config/environments/development.rb", after: "config.action_mailer.raise_delivery_errors = false\n" do <<-CODE

  # Use letter opener for delivering email
  config.action_mailer.delivery_method = :letter_opener
CODE
  end
end
