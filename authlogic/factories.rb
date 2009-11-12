Factory.define :user do |f|
  f.email 'john.doe@example.com'
  f.password 'secret'
  f.password_confirmation 'secret'
  f.first_name 'John'
  f.last_name 'Doe'
end