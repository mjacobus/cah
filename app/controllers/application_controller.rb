class ApplicationController < ActionController::Base
  before_action :set_timezone

  private

  def set_timezone
    Time.zone = 'America/Sao_Paulo'
  end
end
