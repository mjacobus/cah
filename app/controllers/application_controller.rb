class ApplicationController < ActionController::Base
  include DeviseConcern

  before_action :set_timezone
  before_action :authenticate_user!

  private

  def set_timezone
    Time.zone = 'America/Sao_Paulo'
  end
end
