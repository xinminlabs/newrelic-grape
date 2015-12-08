source 'https://rubygems.org'

# Specify your gem's dependencies in newrelic-grape.gemspec
gemspec

case version = ENV['GRAPE_VERSION'] || '~> 0.14.0'
when 'HEAD'
  gem 'grape', github: 'ruby-grape/grape'
else
  gem 'grape', version
end

group :development, :test do
  gem 'rake', '~> 10.0'
  gem 'bundler', '~> 1.0'
  gem 'rspec', '~> 2.6'
  gem 'rack-test', '~> 0.6.2'
end
