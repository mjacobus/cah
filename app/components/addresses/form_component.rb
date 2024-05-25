# frozen_string_literal: true

class Addresses::FormComponent < ApplicationComponent
  attr_reader :address, :circuit, :congregation

  def initialize(address:, circuit: nil, congregation: nil)
    @address = address
    @circuit = circuit
    @congregation = congregation
  end

  def target_url
    return circuit_congregation_address_path(circuit, congregation, address) if edit?

    circuit_congregation_addresses_path(circuit, congregation)
  end

  def method
    edit? ? :patch : :post
  end

  def submit_label
    edit? ? 'Atualizar Endreço' : 'Adicionar Endereço'
  end

  def edit?
    address.id
  end

  def title
    edit? ? 'Editar endereço' : 'Adicionar enderço'
  end

  def cancel_url
    helpers.url_for(action: :index)
  end
end
