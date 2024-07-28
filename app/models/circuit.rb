class Circuit < ApplicationRecord
  has_many :congregations

  def self.ransackable_associations(_auth_object = nil)
    ['congregations']
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id id_value name overseer_name overseer_phone_number updated_at]
  end
end
