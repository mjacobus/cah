class AddressesController < ApplicationController
  def search
    address = Address.find_by!(code: params[:code])

    redirect_to edit_address_path(address) if params[:code]
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Endereço não encontrado.'
    redirect_to(addresses_path)
  end

  def index
    render Addresses::IndexComponent.new(addresses: paginate(addresses), congregation:, circuit:)
  end

  def export
    addresses = self.addresses
    addresses = addresses.with_stage(params[:stage]) if params[:stage]

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
    new_address
    render Addresses::FormComponent.new(address:, congregation:, circuit:)
  end

  def create
    new_address(address_params)

    if address.save
      address.update_geolocation
      flash[:notice] = 'Endereço criado com sucesso'
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
      flash[:notice] = 'Endereço atualizado com sucesso'
      address.update_geolocation
      return redirect_to(action: :index, id: nil)
    end

    flash.now[:alert] = 'Verifique o seu formulário'
    render Addresses::FormComponent.new(address:, congregation:, circuit:)
  end

  def destroy
    address.destroy

    flash[:notice] = 'Endereço removido com sucesso.'
    redirect_to(action: :index, id: nil)
  end

  private

  def address
    @address ||= addresses.find(params[:id])
  end

  def new_address(params = {})
    return @address = congregation.addresses.build(params) if congregation

    @address = Address.build(params)
  end

  def addresses
    @addresses ||= congregation.addresses.with_dependencies.ordered_by_code if congregation
    @addresses ||= Address.with_dependencies.ordered_by_code
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
      verified
      stage
      assignee_notes
      expected_start_date
      expected_finish_date
      congregation_id
      code
    ]

    params.require(:address).permit(*fields)
  end
end
