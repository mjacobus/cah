module Addresses
  class ExportService
    HEADERS = [
      'Código',
      'Nome',
      'Congregação',
      'Telefone',
      'Endereço',
      'Lat/Lon',
      'Etapa',
      'Responsável',
      'Início estimado',
      'Conclusão estimada',
      'Data Atualização'
    ].freeze

    def export_xls(addresses:)
      package = Axlsx::Package.new
      workbook = package.workbook
      sheet = workbook.add_worksheet(name: 'Endereços')
      add_headers_to_worksheet(sheet)

      addresses.find_each(batch_size: 100) do |address|
        add_address(sheet:, address:)
      end

      package
    end

    private

    def add_address(sheet:, address:)
      sheet.add_row([
                      address.code_or_id,
                      address.householder_name,
                      address.congregation.full_description,
                      address.phone_number,
                      address.full_address,
                      address.geolocation.to_s,
                      address.human_stage_name,
                      address.assignee_notes,
                      format_date(address.expected_start_date),
                      format_date(address.expected_finish_date),
                      format_date(address.updated_at)
                    ])
    end

    def add_headers_to_worksheet(sheet)
      sheet.add_row(HEADERS)
    end

    def format_date(date)
      return nil unless date

      date.strftime('%d/%m/%Y')
    end
  end
end
