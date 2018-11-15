require 'uri'
require 'net/http'
require 'json'

module NotifyAwsCost
  class Notify

    attr_reader :webhook_url, :parsed_url
    attr_accessor :name, :icon_url, :icon_emoji

    # 初期化時にnameとかいじれるようにしたい
    # 環境変数(SLACK_WEBHOOK_URL)が設定されていない場合は処理を終了したい
    def initialize
      @webhook_url = ENV['SLACK_WEBHOOK_URL']
      @parsed_url = URI.parse(@webhook_url)
      @name = nil
      @icon_url = nil
      @icon_emoji = nil
    end

    def send(message)
      payload = set_payload(message)
      http = Net::HTTP.new(parsed_url.host, parsed_url.port)
      http.start do
        request = Net::HTTP::Post.new(parsed_url.path)
        request.set_form_data(payload: payload.to_json)
        http.request(request)
      end
    end

    private

    def set_payload(message)
      payload = {}
      payload[:text] = message
      payload[:username] = name unless name.nil?
      payload[:icon_url] = icon_url unless icon_url.nil?
      payload[:icon_emoji] = icon_emoji unless icon_emoji.nil?
      payload
    end

  end
end
