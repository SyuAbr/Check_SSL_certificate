class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include CanCan::ControllerAdditions
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  protect_from_forgery with: :null_session, if: -> { request.format.json? }
end
