if Rails.env.development?
  $redis = Redis.new
else
  $redis = Redis.new(url: ENV["REDIS_URL"])
end
