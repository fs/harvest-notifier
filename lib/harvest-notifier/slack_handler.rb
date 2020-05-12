require "pp"

class SlackHandler
  def call(env)
    req = Rack::Request.new(env)

    puts "Params:"
    puts req.params.inspect

    [200, {"Content-Type" => "text/html"}, ["Hello Slack!"]]
  end
end
