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

    row[:latitude] = begin
      BigDecimal(row[:latitude])
    rescue StandardError
      nil
    end

    row[:longitude] = begin
      BigDecimal(row[:longitude])
    rescue StandardError
      nil
    end

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
end
