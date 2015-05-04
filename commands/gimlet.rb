@commands.pre_bundle do
  add_source "https://dresssed.com/gems/#{ENV['DRESSSED_ID']}/"
  gem "simple_form", "~> 3.1.0"
  gem 'dresssed-gimlet'
end

@commands.post_bundle do
  generate "dresssed:install"
  generate "dresssed:error_pages"
  generate "simple_form:install --bootstrap"
  remove_file "lib/templates/**/_form.html.erb"
end
