require "pp"

class SlackHandler
  def call(env)
    req = Rack::Request.new(env)

    pp req.params

    [200, {"Content-Type" => "text/html"}, ["Hello Slack!"]]
  end
end
