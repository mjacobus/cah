class Congregation < ApplicationRecord
  belongs_to :circuit
  has_many :addresses

  validates :name, presence: true, uniqueness: { scope: :circuit_id, case_sensitive: false }
  validates :number, uniqueness: { case_sensitive: false }, if: -> { number.present? }
  validates :circuit, presence: true

  def to_s
    name
  end

  def full_description
    text = name
    text += " - #{city_name}" if city_name.present?
    text = "#{text} (#{number})" if number.present?
    "#{text} (#{circuit.name})"
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[address circuit_id city_name contact_person_name contact_person_phone_number created_at id
       id_value name number updated_at]
  end
end
