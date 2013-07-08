require 'redis'

$redis = if Rails.env.production?
          uri = URI.parse("redis://redistogo:05e2f7e92a1158f7de291c0b4e347cf8@crestfish.redistogo.com:9187/")
          Redis.new(host: uri.host, port: uri.port, password: uri.password)
        else
          Redis.new
        end
