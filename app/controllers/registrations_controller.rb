class RegistrationsController < Devise::RegistrationsController
  def create
    super

    # Prevent automatic confirmation email handling
    if resource.persisted?
      resource.update(confirmation_token: nil)
    end

    if resource.class.count == 1
      resource.update(admin: true, confirmed_at: Time.now)
    end
  end
end
