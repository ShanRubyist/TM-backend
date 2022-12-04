require "ferrum"

def website_screenshot(url, path = [Rails.root, '/tmp/screenshots/'].join)
  screenshot = [path, filename(url)].join

  browser = Ferrum::Browser.new(timeout: 60)
  browser.go_to(url)
  browser.screenshot(path: screenshot, full: true)
  browser.quit

  return screenshot
end

def filename(url)
  uri = URI(url)
  uri.host.to_s + uri.path.to_s + '_' + Time.now.to_s
end