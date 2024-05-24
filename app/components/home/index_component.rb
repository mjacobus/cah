# frozen_string_literal: true

class Home::IndexComponent < ViewComponent::Base
  def congregations
    @congregations ||= Congregation.order(:city_name).includes(:circuit).all
  end
end
