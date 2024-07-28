ActiveAdmin.register Congregation do
  permit_params :name,
                :number,
                :contact_person_name,
                :contact_person_phone_number,
                :city_name,
                :address,
                :circuit_id

  filter :name
  filter :city_name
  filter :circuit_id
  filter :contact_person_name
  filter :contact_person_number
  filter :number
end
