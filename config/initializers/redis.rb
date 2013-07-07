require 'redis'

$redis = if Rails.env.production? || Rails.env.staging?
          uri = URI.parse(ENV["REDISTOGO_URL"])
          Redis.new(host: uri.host, port: uri.port, password: uri.password)
        else
          Redis.new
        end
