class ApplicationController < ActionController::API
  before_action :cors_set_access_control_headers

  include DeviseTokenAuth::Concerns::SetUserByToken

  render :json

  def cors_preflight_check
    # if request.method == 'OPTIONS'
      render status: 200
    # end
  end

  def cors_set_access_control_headers
    response.headers['Access-Control-Allow-Origin'] = '*'

    # 设置运行浏览器发送的 HTTP 头
    response.headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token, Auth-Token, Email, X-User-Token, X-User-Email'

    # 设置浏览器可以读取到的 HTTP 头
    response.headers['Access-Control-Expose-Headers'] = 'Authorization'

    #response.headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
    #response.headers['Access-Control-Max-Age'] = '1728000'
  end
end
