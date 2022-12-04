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
    fail unless params[:website_id]

    website = current_user.websites.find_by(id: params[:website_id])

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
    fail unless params[:website_id]

    website = current_user.websites.find_by(id: params[:website_id])

    if website
      render json: {
        data: {
          website: website,
          screenshots: website.screenshots.map do |screenshot|
            url_for screenshot
            # rails_storage_proxy_url screenshot
          end
        }
      }
    else
      render_404
    end
  end

  private

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
