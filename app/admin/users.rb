ActiveAdmin.register User do
  filter :email

  permit_params do
    return [] unless current_user.admin?

    permitted = %i[
      email
      encrypted_password
      reset_password_token
      reset_password_sent_at
      remember_created_at
      sign_in_count
      current_sign_in_at
      last_sign_in_at
      current_sign_in_ip
      last_sign_in_ip
      confirmation_token
      confirmed_at
      confirmation_sent_at
      unconfirmed_email
      failed_attempts
      unlock_token
      locked_at
      admin
    ]
  end

  index do
    selectable_column
    id_column

    column :email
    column :sign_in_count
    column :current_sign_in_at
    column :last_sign_in_at
    column :current_sign_in_ip
    column :last_sign_in_ip
    column :confirmed_at
    column :failed_attempts
    column :unlock_token
    column :locked_at
    column :admin

    actions
  end
end
