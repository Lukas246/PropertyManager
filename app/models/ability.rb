class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # hostující uživatel (nepřihlášený)

    if user.admin? # Superadmin
      can :manage, :all
    elsif user.spravce? # Správce objektu

      can :manage, Building, building_assignments: { user_id: user.id }

      # To samé pro místnosti a majetek
      can :manage, Room, building: { building_assignments: { user_id: user.id } }
      can :manage, Asset, room: { building: { building_assignments: { user_id: user.id } } }
    elsif user.ctenar? # Čtenář
      can :read, :all
    end
  end
end
