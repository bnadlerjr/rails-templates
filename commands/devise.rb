@commands.pre_bundle do
  gem "devise", "~> 3.4.1"
  gsub_file "config/environments/production.rb", "config.log_level = :debug", "config.log_level = :warn"
end

@commands.post_bundle do
  generate "devise:install"
  generate "devise user"

  insert_into_file "app/models/user.rb", after: "class User < ActiveRecord::Base\n" do <<-CODE
  enum role: [:user, :admin]
CODE
  end

  generate "migration", "AddRoleToUsers", "role:integer"
  filename = Dir.glob("db/migrate/*add_role_to_users.rb")[0]
  gsub_file filename, "add_column :users, :role, :integer", "add_column :users, :role, :integer, null: false"
end
