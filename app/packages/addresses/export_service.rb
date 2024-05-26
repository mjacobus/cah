module Addresses
  class ExportService
    def initialize(one_sheet_per_congregation: false)
      @one_sheet_per_congregation = one_sheet_per_congregation
    end

    def export_xls(addresses:)
      package = Axlsx::Package.new
      workbook = package.workbook

      query_for(addresses:).find_each(batch_size: 20) do |congregation|
        sheet = worksheet_for(congregation, workbook:)
        add_addresses_to_worksheet(sheet:, congregation:, addresses:)
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

    def worksheet_for(congregation, workbook:)
      if @one_sheet_per_congregation
        sheet = workbook.worksheets.find { |sheet| sheet.name == congregation.name }
        sheet ||= workbook.add_worksheet(name: congregation.name)
        return sheet
      end

      sheet = workbook.worksheets.first
      sheet ||= workbook.add_worksheet(name: "Endereços")
      sheet
    end
  end
end
