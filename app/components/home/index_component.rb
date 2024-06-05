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

  def stats
    @stats ||= Addresses::StatsComponent.new(addresses: Address.all)
  end

  def export_all_url
    export_url(format: :xlsx)
  end

  def export_unresolved_url
    export_url(format: :xlsx, unresolved: true)
  end
end
