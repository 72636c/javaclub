source "https://rubygems.org"

ruby ">=2.2.2"

gem "json"
gem "activerecord"
gem "sinatra", ">= 2.0.0"
gem "sinatra-activerecord", ">= 2.0.12"
gem "sinatra-flash", ">= 0.3.0"
gem "sinatra-redirect-with-flash", ">= 0.2.1"

group :development do
  gem "sqlite3"
  gem "tux", ">= 0.3.0"
end

group :test do
  gem "nokogiri"
  gem "rack-test", ">= 0.6.3"
  gem "rspec"
end

group :test, :production do
  gem "pg"
  gem "rake"
end
