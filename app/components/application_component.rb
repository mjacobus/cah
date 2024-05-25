class ApplicationComponent < ViewComponent::Base
  def boolean(value, nil_value: nil)
    return nil_value if value.nil? && nil_value

    value ? 'Sim' : 'Não'
  end
end
