# frozen_string_literal: true

class Home::IndexComponent < ApplicationComponent
  def congregations
    @congregations ||= Congregation.order(:city_name, :name).includes(:circuit).all
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

  def export_xls_url(**params)
    export_url(format: :xlsx, **params)
  end
end
