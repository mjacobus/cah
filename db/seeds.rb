c1 = Circuit.find_or_create_by!(name: 'RS-111') do |c|
  c.overseer_name = 'John Doe'
  c.overseer_phone_number = '51 99999-8888'
end

c2 = Circuit.find_or_create_by!(name: 'RS-222') do |c|
  c.overseer_name = 'Jane Doe'
  c.overseer_phone_number = '51 99999-7777'
end

Congregation.find_or_create_by!(name: 'Sul', circuit_id: c1.id) do |c|
  c.city_name = 'Nova York'
end

Congregation.find_or_create_by!(name: 'Norte', circuit_id: c1.id) do |c|
  c.city_name = 'Nova York'
end

Congregation.find_or_create_by!(name: 'Sul', circuit_id: c1.id) do |c|
  c.city_name = 'Nova Jersey'
end

Congregation.find_or_create_by!(name: 'Norte', circuit_id: c2.id) do |c|
  c.city_name = 'California'
end

Congregation.find_or_create_by!(name: 'Sul', circuit_id: c2.id) do |c|
  c.city_name = 'California'
end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?