class RedisStack
  def initialize(cache_key)
    @cache_key = cache_key
  end

  def get
    $redis.get @cache_key
  end

  def push(value)
    $redis.lpush @cache_key, value
  end

  def pop
    $redis.lpop @cache_key
  end
end
