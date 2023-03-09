source "https://rubygems.org"

ruby ">=2.2.2"

gem "json"
gem "activerecord"
gem "sinatra", ">= 2.0.0"
gem "sinatra-activerecord"
gem "sinatra-flash"
gem "sinatra-redirect-with-flash"

group :development do
  gem "sqlite3"
  gem "tux"
end

group :test do
  gem "nokogiri", ">= 1.10.5"
  gem "rack-test"
  gem "rspec"
end

group :test, :production do
  gem "pg"
  gem "rake"
end
