class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # hostující uživatel (nepřihlášený)

    if user.admin? # Superadmin
      can :manage, :all
    elsif user.spravce? # Správce objektu
      can :read, :all
      # CRUD jen pro majetek v budovách, které spravuje (logiku doladíme později)
      can :manage, Asset
      can :manage, Room
    elsif user.ctenar? # Čtenář
      can :read, :all
    end
  end
end
