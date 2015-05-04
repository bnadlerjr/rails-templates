@commands.pre_bundle do
  gem "bullet", "~> 4.14.5", group: :development
  insert_into_file "config/environments/development.rb", after: "# config.action_view.raise_on_missing_translations = true\n" do <<-CODE

  config.after_initialize do
    Bullet.enable = true
    Bullet.add_footer = true
    Bullet.rails_logger = true
    Bullet.raise = true
  end
CODE
  end
end
