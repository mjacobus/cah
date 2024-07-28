# frozen_string_literal: true

class Addresses::FormComponent < ApplicationComponent
  attr_reader :address, :circuit, :congregation

  def initialize(address:, circuit: nil, congregation: nil)
    @address = address
    @circuit = circuit
    @congregation = congregation
  end

  def target_url
    return circuit_congregation_address_path(circuit, congregation, address) if edit? && circuit && congregation

    return circuit_congregation_addresses_path(circuit, congregation) if circuit && congregation

    return address_path(address) if edit?

    addresses_path
  end

  def congregation_options
    ids = Congregation.order(:name, :city_name).map { |c| [c.full_description, c.id] }
    ids.unshift(['Selecione uma congregação', ''])
  end

  def stage_options
    [
      [address_stage(Address.new(stage: :pending)), :pending],
      [address_stage(Address.new(stage: :in_progress)), :in_progress],
      [address_stage(Address.new(stage: :done)), :done]
    ]
  end

  def method
    edit? ? :patch : :post
  end

  def submit_label
    edit? ? 'Atualizar Endereço' : 'Adicionar Endereço'
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

  def last_code_info
    id = Address.order(:id).last&.code
    return unless id

    "Último cadastrado: #{id}"
  end

  def destroy_link
    return unless edit?

    link_to(
      'Excluir',
      address_path(address),
      method: :delete,
      data: { confirm: 'Tem certeza que deseja excluir?' },
      class: 'btn btn-danger'
    )
  end
end
