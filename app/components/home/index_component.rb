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
    link_to('Endereços', path)
  end
end
