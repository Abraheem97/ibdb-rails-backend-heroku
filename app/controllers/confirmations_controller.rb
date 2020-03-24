class ConfirmationsController < Devise::ConfirmationsController

  private

  def after_confirmation_path_for(resource_name, resource)
    'https://ibdb-react-frontend.herokuapp.com/login'
  end

end