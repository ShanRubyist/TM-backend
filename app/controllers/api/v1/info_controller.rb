class Api::V1::InfoController < ApplicationController
  def info
    render json: {
      users_count: User.count,
      websites_count: Website.count,
      screenshots_count: ActiveStorage::Blob.count
    }
  end
end
