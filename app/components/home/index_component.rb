# frozen_string_literal: true

class Home::IndexComponent < ViewComponent::Base
  def congregations
    @congregations ||= Congregation.order(:city_name).includes(:circuit).all
  end

  def addresses_link(congregation)
    path = circuit_congregation_addresses_path(
      congregation.circuit,
      congregation
    )
    link_to(congregation.full_description, path)
  end

  def total_addresses
    @total_addresses ||= Address.count
  end

  def verified_addresses
    @verified_addresses ||= Address.where(verified: true).count
  end

  def resolved_addresses
    0
    # TODO:
    # @resolved_addresses ||= Address.where(resolved: true).count
  end
end
