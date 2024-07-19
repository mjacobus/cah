module Addresses
  class ExportService
    HEADERS = [
      'Código',
      'Nome',
      'Telefone',
      'Endereço',
      'Lat/Lon',
      'Etapa',
      'Responsável',
      'Início estimado',
      'Conclusão estimada',
      'Data Atualização'
    ].freeze

    def initialize(one_sheet_per_congregation: false)
      @one_sheet_per_congregation = one_sheet_per_congregation
    end

    def export_xls(addresses:)
      package = Axlsx::Package.new
      workbook = package.workbook

      query_for(addresses:).find_each(batch_size: 50) do |congregation|
        sheet = worksheet_for(congregation, workbook:)
        add_addresses_to_worksheet(sheet:, congregation:, addresses:)
      end

      package
    end

    private

    def add_addresses_to_worksheet(sheet:, congregation:, addresses:)
      congregation_addresses(congregation:, addresses:).find_each(batch_size: 100) do |address|
        sheet.add_row([
                        address.code_or_id,
                        address.householder_name,
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
        sheet ||= workbook.add_worksheet(name: congregation.name).tap do |sheet|
          add_headers_to_worksheet(sheet)
        end
        return sheet
      end

      sheet = workbook.worksheets.first
      sheet ||= workbook.add_worksheet(name: 'Endereços').tap do |sheet|
        add_headers_to_worksheet(sheet)
      end
      sheet
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
