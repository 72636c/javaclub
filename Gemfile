source "https://rubygems.org"

ruby ">=2.2.2"

gem "json", ">= 2.3.0"
gem "activerecord", ">= 6.1.7.3"
gem "sinatra", ">= 2.2.3"
gem "sinatra-activerecord"
gem "sinatra-flash"
gem "sinatra-redirect-with-flash"

group :development do
  gem "sqlite3"
  gem "tux"
end

group :test do
  gem "nokogiri", ">= 1.13.9"
  gem "rack-test"
  gem "rspec"
end

group :test, :production do
  gem "pg"
  gem "rake", ">= 12.3.3"
end
