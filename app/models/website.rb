class Website < ApplicationRecord
  belongs_to :user
  has_many_attached :screenshots
end
