class Congregation < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :circuit_id }
  validates :number
end
