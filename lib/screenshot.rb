require "ferrum"

def website_screenshot(url, format='png', path = [Rails.root, '/tmp/screenshots/'].join)
  format = 'jpeg' if format == 'jpg'
  raise unless %w(jpeg, png).include?(format)

  screenshot = [path, filename(url, format)].join

  browser = Ferrum::Browser.new(timeout: 60)
  browser.go_to(url)
  browser.screenshot(path: screenshot, format: format, full: true)
  browser.quit

  return screenshot
end

def filename(url, format='png')
  format = 'jpg' if format == 'jpeg'
  raise unless %w(jpeg, png).include?(format)

  uri = URI(url)
  "#{uri.host}_#{uri.path.to_s.sub('/', '')}-#{Time.new.month}-#{Time.new.day}-#{Time.new.hour}:#{Time.new.min}:#{Time.new.sec}.#{format}"
end