class RedisStack
  def initialize(cache_key)
    @cache_key = cache_key
  end

  def last
    JSON.parse $redis.lindex(@cache_key, $redis.llen(@cache_key)-1), symbolize_names: true
  end

  def push(value)
    $redis.lpush @cache_key, value.to_json
  end

  def pop
    JSON.parse $redis.lpop(@cache_key), symbolize_names: true
  end
end
