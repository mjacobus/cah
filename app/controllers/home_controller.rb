class HomeController < ApplicationController
  def index
    render Home::IndexComponent.new
  end
end
