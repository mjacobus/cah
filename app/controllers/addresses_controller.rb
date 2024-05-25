class AddressesController < ApplicationController
  def index
    render Addresses::IndexComponent.new(addresses:, congregation:, circuit:)
  end

  def edit
    render Addresses::EditComponent.new(address:)
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
end
