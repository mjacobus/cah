class ApplicationController < ActionController::Base
  include DeviseConcern

  before_action :set_timezone
  before_action :authenticate_user!

  private

  def set_timezone
    Time.zone = 'America/Sao_Paulo'
  end

  def paginate(scope)
    scope.page(params[:page]).per(per_page)
  end

  def per_page
    number = params[:per_page].to_i
    return 100 unless number.positive?

    [number, 100].min
  end
end
