class SlackHandler
  def call(env)
    req = Rack::Request.new(env)

    [200, {"Content-Type" => "text/html"}, ["Hello Slack!"]]
  end
end
