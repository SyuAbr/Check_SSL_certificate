class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # гость

    if user.role == 'Администратор'
      can :manage, :all
    elsif user.role == 'Сотрудник'
      can :read, User, id: user.id
      can :update, User, id: user.id
    end
  end
end
