require "ferrum"

def website_screenshot(url, format='png', path = [Rails.root, '/tmp/screenshots/'].join)
  screenshot = [path, filename(url)].join

  browser = Ferrum::Browser.new(timeout: 60)
  browser.go_to(url)
  browser.screenshot(path: screenshot, format: format, full: true)
  browser.quit

  return screenshot
end

def filename(url, format)
  uri = URI(url)
  uri.host.to_s + '_' + uri.path.to_s.sub('/', '') + '_' + Time.now.to_s + '.png'
end