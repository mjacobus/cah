# frozen_string_literal: true

class InputErrorComponent < ApplicationComponent
  def initialize(record:, field_name:)
    @record = record
    @field_name = field_name
  end

  def render?
    @record.errors[@field_name].any?
  end

  def error_messages
    @record.errors[@field_name].join(', ')
  end
end
