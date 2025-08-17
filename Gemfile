source "https://rubygems.org"

ruby ">=2.2.2"

gem "json"
gem "activerecord", ">= 7.1.5.2"
gem "sinatra"
gem "sinatra-activerecord", ">= 2.0.13"
gem "sinatra-flash"
gem "sinatra-redirect-with-flash"

group :development do
  gem "sqlite3"
  gem "tux"
end

group :test do
  gem "nokogiri"
  gem "rack-test"
  gem "rspec"
end

group :test, :production do
  gem "pg"
  gem "rake"
end
