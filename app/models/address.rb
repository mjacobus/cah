class Address < ApplicationRecord
  belongs_to :congregation

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
