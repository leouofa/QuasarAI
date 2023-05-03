module RestrictedAccess
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :check_access
  end

  private

  def check_access
    redirect_to unauthorized_index_path unless current_user.has_access?
  end
end
