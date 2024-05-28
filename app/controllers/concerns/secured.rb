# ./app/controllers/concerns/secured.rb
module Secured
  extend ActiveSupport::Concern

  included do
    before_action :logged_in_using_omniauth?, except: [:index, :show]
  end

  def logged_in_using_omniauth?
    redirect_to '/' unless session[:userinfo].present?
  end
end
