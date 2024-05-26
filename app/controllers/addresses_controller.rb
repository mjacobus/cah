class AddressesController < ApplicationController
  def index
    render Addresses::IndexComponent.new(addresses:, congregation:, circuit:)
  end

  def export
    addresses = self.addresses
    addresses = addresses.unresolved if params[:unresolved]

    service = Addresses::ExportService.new(one_sheet_per_congregation: false)
    package = service.export_xls(addresses:)

    respond_to do |format|
      format.xlsx do
        filename_parts = ['Endereços']
        filename_parts << congregation.full_description if congregation
        filename_parts << Time.zone.now.strftime('%Y-%m-%d%-H%M%S')
        filename = filename_parts.join('-').parameterize
        filename = "#{filename}.xlsx"
        response.headers['Content-Disposition'] = "attachment; filename=#{filename}"
        render body: package.to_stream.read
      end
    end
  end

  def new
    address = congregation.addresses.build
    render Addresses::FormComponent.new(address:, congregation:, circuit:)
  end

  def create
    address = congregation.addresses.build(address_params)

    if address.save
      address.update_geolocation
      flash[:notice] = 'Endreço criado com sucesso'
      return redirect_to(action: :index, id: nil)
    end

    flash.now[:alert] = 'Verifique o seu formulário'
    render Addresses::FormComponent.new(address:, congregation:, circuit:)
  end

  def edit
    render Addresses::FormComponent.new(address:, congregation:, circuit:)
  end

  def update
    if address.update(address_params)
      flash[:notice] = 'Endreço atualizado com sucesso'
      address.update_geolocation
      return redirect_to(action: :index, id: nil)
    end

    flash.now[:alert] = 'Verifique o seu formulário'
    render Addresses::FormComponent.new(address:, congregation:, circuit:)
  end

  private

  def address
    @address ||= addresses.find(params[:id])
  end

  def addresses
    @addresses ||= congregation.addresses.ordered_by_householder_name if congregation
    @addresses ||= Address.ordered_by_householder_name
    @addresses
  end

  def congregation
    return @congregation if defined?(@congregation)

    return unless params[:congregation_id]

    @congregation = circuit.congregations.find(params[:congregation_id])
  end

  def circuit
    return @circuit if defined?(@circuit)

    return unless params[:circuit_id]

    @circuit = Circuit.find(params[:circuit_id])
  end

  def address_params
    fields = %i[
      householder_name
      street_name
      neighborhood
      postal_code
      phone_number
      city_name
      complement
      number
      latitude
      longitude
      resolved
      verified
    ]

    params.require(:address).permit(*fields)
  end
end
