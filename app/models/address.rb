class Address < ApplicationRecord
  belongs_to :congregation

  validates :householder_name, presence: true
  validates :street_name, presence: true
  validates :number, presence: true
  validates :city_name, presence: true

  scope :ordered_by_householder_name, ->(direction: :asc) { order(householder_name: direction) }

  def full_address
    [
      street_name,
      number,
      complement,
      neighborhood,
      city_name
    ].map(&:presence).compact.join(', ')
  end

  def geolocation
    return unless latitude.present? && longitude.present?

    Geolocation.new(latitude, longitude)
  end
end
