class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :lockable,
         :timeoutable,
         :trackable

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      admin
      confirmation_sent_at
      confirmation_token
      confirmed_at
      created_at
      current_sign_in_at
      current_sign_in_ip
      email
      encrypted_password
      failed_attempts
      id
      id_value
      last_sign_in_at
      last_sign_in_ip
      locked_at
      remember_created_at
      reset_password_sent_at
      reset_password_token
      sign_in_count
      unconfirmed_email
      unlock_token
      updated_at
    ]
  end
end
