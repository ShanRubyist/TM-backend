class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  render :json
end
