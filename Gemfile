source "http://gems.ruby-china.com"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# ruby "2.7.6"

# headless chromium
#
# Download it from official source for Chrome or Chromium.
# Chrome binary should be in the PATH or BROWSER_PATH
# See https://github.com/rubycdp/ferrum
#
# Also need fonts-noto-cjk
#     # apt-get install chromium fonts-noto-cjk
#     # fonts-noto-cjk 是中、日、韩字体。没有安装时ferrum截屏的字体会丢失，显示方框
# 不知道为什么这个需要放在前面，否则有些环境会运行出错
gem "ferrum"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails'

end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

gem 'devise'
gem 'devise_token_auth'

gem 'dotenv-rails'

gem "activestorage-aliyun"

gem 'whenever', require: false

gem 'sidekiq', '< 6.0'

