class Address < ApplicationRecord
  belongs_to :congregation

  validates :householder_name, presence: true
  validates :street_name, presence: true
  validates :number, presence: true
  validates :city_name, presence: true
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90, allow_nil: true }
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90, allow_nil: true }

  scope :ordered_by_householder_name, ->(direction: :asc) { order(householder_name: direction) }
  scope :unresolved, -> { where(resolved: false) }
  scope :resolved, -> { where(resolved: true) }

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

  def update_geolocation(force: false)
    return if force == false && geolocation.present?

    client = GoogleMaps::Client.create
    service = GoogleMaps::Service.new(client)
    data = service.get_location(address: address_for_google_lookup)

    location = data.dig('results', 0, 'geometry', 'location')

    raise("Error saving address #{location['error']}") if location['error']

    self.latitude = location['lat']
    self.longitude = location['lng']
    save || raise("Error saving address #{errors.full_messages}")
  rescue RuntimeError => e
    Rails.logger.info("Error updating geolocation for account #{id}: #{e.message}")
    raise e if Rails.env.development?
  end

  private

  def address_for_google_lookup
    parts = []
    parts << [street_name, number].join(' ')
    parts << neighborhood
    parts << city_name
    parts << postal_code
    parts.compact.join(', ')
  end
end
