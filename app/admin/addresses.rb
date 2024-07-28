ActiveAdmin.register Address do
  filter :householder_name

  permit_params :householder_name,
                :phone_number,
                :street_name,
                :number,
                :complement,
                :postal_code,
                :neighborhood,
                :city_name,
                :latitude,
                :longitude,
                :verified,
                :congregation_id,
                :stage,
                :assignee_notes,
                :expected_start_date,
                :expected_finish_date,
                :code

  index do
    selectable_column
    id_column

    column :code
    column :householder_name
    column :full_address do |address|
      address.full_address
    end
    column :city_name
    column :congregation
    column :stage do |address|
      address.human_stage_name
    end
    column :assignee_notes
    column :expected_start_date
    column :expected_finish_date

    actions
  end
end
