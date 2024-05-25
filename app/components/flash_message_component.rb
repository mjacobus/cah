# frozen_string_literal: true

class FlashMessageComponent < ApplicationComponent
  def initialize(flash:)
    @flash = flash
  end

  def flash_class(level)
    case level.to_sym
    when :notice then 'alert alert-success'
    when :alert then 'alert alert-danger'
    else 'alert alert-info'
    end
  end
end
