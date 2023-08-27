require 'screenshot'

class WebsiteScreenshotJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Website.all.each do |website|
      img = website_screenshot(website.url) rescue Rails.logger.error('#{website.url} screenshot failed')
      upload_screenshot_to_oss(website, img, filename(website.url)) rescue Rails.logger.error('#{website.url} upload screenshot to oss failed')
    end
  end

  private

  def upload_screenshot_to_oss(website, screenshot, oss_filename = Time.now.to_s)
    website.screenshots.attach(io: File.open(screenshot), filename: oss_filename)
  end
end
