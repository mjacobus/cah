class ApplicationComponent < ViewComponent::Base
  def boolean(value, nil_value: nil)
    return nil_value if value.nil? && nil_value

    value ? 'Sim' : 'Não'
  end

  def add_title(title)
    helpers.add_page_title(title)
  end
end
