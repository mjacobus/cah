class AddressesController < ApplicationController
  def index
    render Addresses::IndexComponent.new(addresses:, congregation:, circuit:)
  end

  def new
    address = congregation.addresses.build
    render Addresses::FormComponent.new(address:, congregation:, circuit:)
  end

  def create
    address = congregation.addresses.build(address_params)

    if address.save
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
    @addresses ||= congregation.addresses.ordered_by_householder_name
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
    ]

    params.require(:address).permit(*fields)
  end
end
