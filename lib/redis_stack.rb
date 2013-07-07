class RedisStack
  def initialize(cache_key)
    @cache_key = cache_key
  end

  def all
    result = $redis.lrange cache_key, 0, $redis.llen(cache_key)
    return unless result.present?
    result.map { |x| JSON.parse(x) }
  end

  def last
    result = $redis.lindex(@cache_key, 0)
    return unless result
    JSON.parse result
  end

  def push(value)
    $redis.lpush @cache_key, value.to_json
  end

  def pop
    result = $redis.lpop(@cache_key)
    return unless result
    JSON.parse result
  end

  def clear_stack(confirm)
    raise 'You need to pass a confirmation token' unless confirm == 'totally_serious'
    $redis.del @cache_key
  end
end
