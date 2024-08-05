# frozen_string_literal: true

class NavbarComponent < ApplicationComponent
  def render?
    helpers.current_user.present?
  end

  def search_path
    helpers.search_addresses_path
  end
end
