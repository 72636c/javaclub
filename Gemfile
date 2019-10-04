source "https://rubygems.org"

ruby ">=2.2.2"

gem "json"
gem "activerecord"
gem "sinatra"
gem "sinatra-activerecord"
gem "sinatra-flash"
gem "sinatra-redirect-with-flash"

group :development do
  gem "sqlite3"
  gem "tux"
end

group :test do
  gem "nokogiri", ">= 1.8.3"
  gem "rack-test"
  gem "rspec"
end

group :test, :production do
  gem "pg"
  gem "rake"
end
