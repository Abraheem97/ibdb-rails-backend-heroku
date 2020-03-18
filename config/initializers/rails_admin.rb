RailsAdmin.config do |config|
  
    ### Popular gems integration
    config.parent_controller = '::ApplicationController'
  @super_admin = User.find_by_email("superadmin@ibdb.com")
  ## == Devise ==
   config.authenticate_with do
     warden.authenticate! scope: :user
   end
   config.current_user_method(&:current_user)

  ## == CancanCan ==
  config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  # if current_user.admin_role?
  #   config.model 'User' do
  #     create do
  #       field :email
  #       field :password
  #       field :confirmed_at
  #       field :moderator_role
  #       field :user_role
  #     end
    
  #   end
  

config.model 'User' do
  create do
    include_fields :email, :password, :confirmed_at, :user_role, :moderator_role
    
    field :admin_role do
      visible do        
        bindings[:view].current_user.superadmin?
      end
    end

  end
  
  
  edit do
    include_fields :email, :password, :confirmed_at, :user_role, :moderator_role
    
    field :admin_role do
      visible do        
        bindings[:view].current_user.superadmin?
      end
    end
  end
end


end
