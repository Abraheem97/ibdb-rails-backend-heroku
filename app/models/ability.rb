# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.superadmin?
      can :manage, :all
      can :manage, :rails_admin
      can :manage, :dashboard
    end

    if user.admin_role?
      can :access, :rails_admin
      can :manage, :dashboard
      can :read, User
      can :destroy, User, superadmin: false, admin_role: false
      can :edit, User, superadmin: false, admin_role: false
      can :create, User
      can :manage, Book
      can :manage, Comment
      can :manage, Review
      can :manage, Author
    end

    if user.moderator_role?
      can :manage, User, superadmin: false, admin_role: false, moderator_role?: false
      can :manage, Book
      can :manage, Comment
      can :manage, Review
    end

    if user.user_role?
      can :read, Author
      can :read, Book
    end

    can :delete, Comment, user_id: user.id
    can :delete, Review, user_id: user.id
  end
end
