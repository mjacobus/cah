# frozen_string_literal: true

class Addresses::EditComponent < ApplicationComponent
  attr_reader :address, :circuit, :congregation

  def initialize(address:, circuit: nil, congregation: nil)
    @address = address
    @circuit = circuit
    @congregation = congregation
  end

  def target_url
    circuit_congregation_address_path(
      circuit, congregation, address
    )
  end

  def method
    :patch
  end

  def submit_label
    'Atualizar'
  end
end
