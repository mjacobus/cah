# frozen_string_literal: true

class Home::IndexComponent < ViewComponent::Base
  def congregations
    @congregations ||= Congregation.includes(:circuit).all
  end
end
