namespace :db do
  desc 'Adds a user to the database'
  task :add_user => :environment do
    email = prompt('Enter Email: ')
    first_name = prompt('First Name: ')
    last_name = prompt('Last Name: ')
    password = prompt('Password: ')
    password_confirmation = prompt('Confirm Password: ')
    admin = prompt('Admin? (y/n): ')

    u = User.create({
      :email => email,
      :first_name => first_name,
      :last_name => last_name,
      :password => password,
      :password_confirmation => password_confirmation
    })

    u.add_role("admin") if 'y' == admin.downcase
    u.save
  end
end

private

def prompt(text)
  print text
  STDIN.gets.chomp
end
