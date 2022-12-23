class Api::V1::WebsitesController < ApplicationController
  before_action :authenticate_user!

  def index
    websites = current_user.websites

    render json: {
      data: {
        websites: websites.map(&:to_json)
      }
    }
  end

  def create
    website = current_user.websites.create(url: params[:url])

    render json: {
      data: website.to_json
    }
  end

  def show
    screenshots
  end

  def update
  end

  def destroy
    fail unless params[:id]

    website = current_user.websites.find_by(id: params[:id])

    if website && website.destroy!
      render json: {
        data: {
          message: 'website delete success'
        }
      }
    else
      render_5xx
    end
  end

  def screenshots
    fail unless params[:id]

    params[:per] ||= 20
    params[:page] ||= 1

    website = current_user.websites.find_by(id: params[:id])

    if website
      render json: {
        data: {
          website: website,
          screenshots:
            website
              .screenshots
              .offset(params[:per] * (params[:page] - 1))
              .limit(params[:page])
              .order("created_at desc")
              .map do |screenshot|
              {
                # url_for screenshot
                # rails_storage_proxy_url screenshot
                img: cdn_url(screenshot),
                created_at: screenshot.created_at.localtime.strftime("%Y-%m-%d %H:%M:%S")
              }
            end
        }
      }
    else
      render_404
    end
  end

  private

  def cdn_url(screenshot)
    cdn_host = ENV.fetch('CDN_HOST') {}

    uri = URI(rails_storage_proxy_url(screenshot))
    uri.host = cdn_host if cdn_host && cdn_host.present?
    uri.to_s
  end

  def render_404
    render json: {
      data: {
        message: 'Not Found'
      },
      status: :not_found
    }
  end

  def render_5xx
    render json: {
      data: {
        message: 'Server Error'
      },
      status: 500
    }
  end
end
