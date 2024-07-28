ActiveAdmin.register Circuit do
  filter :name
  filter :overseer_name
  filter :overseer_phone_number
  filter :created_at
  filter :updated_at

  permit_params :name, :overseer_name, :overseer_phone_number
end
