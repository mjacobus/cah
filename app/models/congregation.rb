class Congregation < ApplicationRecord
  belongs_to :circuit

  validates :name, presence: true, uniqueness: { scope: :circuit_id, case_sensitive: false }
  validates :number, uniqueness: { case_sensitive: false }, if: -> { number.present? }
  validates :circuit, presence: true

  def to_s
    name
  end
end
