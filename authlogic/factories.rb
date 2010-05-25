Factory.define :user do |f|
  f.email 'john.doe@example.com'
  f.password 'secret'
  f.password_confirmation 'secret'
  f.first_name 'John'
  f.last_name 'Doe'
end

Factory.define :jane, :class => User do |f|
  f.email 'jane.doe@example.com'
  f.password 'secret'
  f.password_confirmation 'secret'
  f.first_name 'Jane'
  f.last_name 'Doe'
  f.persistence_token 'bar'
  f.single_access_token 'baz'
  f.perishable_token 'foo'
end
