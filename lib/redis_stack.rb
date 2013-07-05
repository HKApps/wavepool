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
    result = $redis.lpop(@cache_key)
    return unless result
    JSON.parse result, symbolize_names: true
  end
end
