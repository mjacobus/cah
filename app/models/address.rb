class Address < ApplicationRecord
  belongs_to :congregation

  enum stage: { pending: 0, in_progress: 1, done: 2 }

  validates :householder_name, presence: true
  validates :street_name, presence: true
  validates :number, presence: true
  validates :city_name, presence: true
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90, allow_nil: true }
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90, allow_nil: true }
  validates :stage, presence: true
  validates :code, uniqueness: { case_sensitive: false }
  validates :congregation, presence: true

  scope :ordered_by_householder_name, ->(direction: :asc) { order(householder_name: direction) }
  scope :ordered_by_code, lambda { |direction: :asc|
    direction = { asc: :asc, desc: :desc }[direction.to_sym] || :asc
    sql = "CASE WHEN code REGEXP '^[0-9]+$' THEN LPAD(code, 10, '0') ELSE code END #{direction.upcase}"
    order(Arel.sql(sql))
  }
  scope :with_stage, ->(stage) { where(stage:) }
  scope :with_dependencies, -> { includes(congregation: :circuit) }

  def full_address
    value = [
      street_name,
      number,
      complement,
      neighborhood,
      city_name
    ].map(&:presence).compact.join(', ')

    value += " - #{postal_code}" if postal_code.present?

    value
  end

  def geolocation
    return unless latitude.present? && longitude.present?

    Geolocation.new(latitude, longitude)
  end

  def code_or_id
    code || "id-#{id}"
  end

  def update_geolocation(force: false)
    return if force == false && geolocation.present?

    client = GoogleMaps::Client.create
    service = GoogleMaps::Service.new(client)
    data = service.get_location(address: address_for_google_lookup)

    location = data.dig('results', 0, 'geometry', 'location')

    unless location
      Rails.logger.info("No location for address #{id}")
      return
    end

    raise("Error saving address #{location['error']}") if location && location['error']

    self.latitude = location['lat']
    self.longitude = location['lng']
    save || raise("Error saving address #{errors.full_messages}")
  rescue RuntimeError => e
    Rails.logger.info("Error updating geolocation for address #{id}: #{e.message}")
  end

  def human_stage_name
    I18n.t("activerecord.attributes.address.stages.#{stage}")
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
