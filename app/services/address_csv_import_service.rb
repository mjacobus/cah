require 'csv'

class AddressCsvImportService
  COLUMNS = %i[
    circuit_name
    congregation_name
    householder_name
    householder_phone_number
    neighborhood
    street_name
    number
    complement
    postal_code
    latitude
    longitude
  ].freeze

  def import_csv(url:)
    response = HTTParty.get(url)

    CSV.parse(response.body, headers: true) do |row|
      values = parse(row.to_h.symbolize_keys)
      import_row(values)
    end
  end

  private

  def parse(row)
    COLUMNS.each do |column|
      row.fetch(column) do
        raise "Columns required: #{COLUMNS.join(',')}"
      end
    end

    row[:latitude] = to_decimal(row[:latitude]) || from_lat_lon(row)[0]
    row[:longitude] = to_decimal(row[:longitude]) || from_lat_lon(row)[1]

    row
  end

  def import_row(row)
    circuit = Circuit.find_or_create_by!(name: row[:circuit_name])
    congregation = Congregation.find_or_create_by!(
      name: row[:congregation_name],
      circuit_id: circuit.id
    ) do |c|
      c.circuit = circuit
    end

    address = Address.new(
      congregation:,
      city_name: row[:city_name],
      householder_name: row[:householder_name],
      phone_number: row[:householder_phone_number],
      neighborhood: row[:neighborhood],
      street_name: row[:street_name],
      number: row[:number],
      complement: row[:complement],
      postal_code: row[:postal_code],
      latitude: row[:latitude],
      longitude: row[:longitude]
    )

    address.save!
  end

  def to_decimal(value)
    BigDecimal(value)
  rescue ArgumentError
    nil
  end

  # @return [Array<BigDecimal>] or empty array when the value is not valid
  def from_lat_lon(row)
    value = row[:lat_lon].to_s.split(',')
    value = value.map(&:strip).map do |value|
      to_decimal(value)
    end

    value = value[0..1]

    return [] unless value.size == 2

    value
  end
end
