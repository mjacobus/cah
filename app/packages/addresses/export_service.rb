module Addresses
  class ExportService
    def export_xls(addresses)
      package = Axlsx::Package.new
      wb = package.workbook

      query_for(addresses:).find_each(batch_size: 20) do |congregation|
        wb.add_worksheet(name: congregation.name) do |sheet|
          add_addresses_to_worksheet(sheet:, congregation:, addresses:)
        end
      end

      package
    end

    # private

    def add_addresses_to_worksheet(sheet:, congregation:, addresses:)
      sheet.add_row([
        "Nome",
        "Congregação",
        "Telefone",
        "Rua",
        "Número",
        "Complemento",
        "Bairro",
        "Cidade",
        "CEP",
        "Lat/Lon",
        "Código",
        "Atualizado",
      ])

      congregation_addresses(congregation:, addresses:).find_each(batch_size: 100) do |address|
        sheet.add_row([
          address.householder_name,
          congregation.full_description,
          address.phone_number,
          address.street_name,
          address.number,
          address.complement,
          address.neighborhood,
          address.city_name,
          address.postal_code,
          address.geolocation.to_s,
          address.id,
          address.updated_at,
        ])
      end
    end

    def query_for(addresses:)
      congregation_ids = addresses.select(:congregation_id)
      Congregation.where(id: congregation_ids).includes(:addresses)
    end

    def congregation_addresses(congregation:, addresses:)
      congregation.addresses.where(id: addresses.select(:id))
    end
  end
end
