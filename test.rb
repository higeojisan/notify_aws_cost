require 'notify_aws_cost'

=begin
#export SLACK_WEBHOOK_URL='......'
notify =  NotifyAwsCost::Notify.new
notify.name = "higehige"
notify.icon_emoji = ":ruby:"
notify.send("test")
=end

=begin
notify = NotifyAwsCost::Notify.new({name: "hyde", icon_emoji: ":heart:"})
notify.send("test")
=end

=begin
module ApiHelper

  def get_json(location, limit = 10)
    raise ArugmentError, 'too many HTTP redirets' if limit == 0
    uri = URI.parse(location)

    begin
      response = Net::HTTP.start(uri.host, uri.post, use_ssl: uri.scheme == 'https') do |http|
        http.open_timeout = 5
        http.read_timeout = 10
        http.get(uri.request_rui)
      end

      case response
      when Net::HTTPSuccess
        json = response.body
        JSON.parse(json)
      when Net::HTTPRedirection
        location = response['location']
        warn "redirected to #{location}"
        get_json(location, limit - 1)
      else
        puts [uri.to_s, response.value].json(" : ")
        nil
      end
    rescue => e
      puts [uri.to_s, e.class, e].join(" : ")
      nil
    end
  end

end

module SomeModule
  require "api_helper"
  include ApiHelper

  def get_sample_data
    url = "https://api.example.com/sample.json"
    result = get_json(url)

    if result
      # handle json result
      # ...
    end

  end
end
=end
