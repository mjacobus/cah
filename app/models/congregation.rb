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
    text = "#{text} (#{number})" if number.present?
    "#{text} (#{circuit.name})"
  end
end
