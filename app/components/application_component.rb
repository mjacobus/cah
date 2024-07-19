class ApplicationComponent < ViewComponent::Base
  def boolean(value, nil_value: nil)
    return nil_value if value.nil? && nil_value

    value ? 'Sim' : 'Não'
  end

  def format_date(date, format: :default)
    return if date.nil?

    date = date.in_time_zone('Brasilia') if date.is_a?(Time)

    l(date.to_date, format:)
  end

  def add_title(title)
    helpers.add_page_title(title)
  end

  def address_stage(address)
    address.human_stage_name
  end
end
