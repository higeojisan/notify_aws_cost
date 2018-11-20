require 'uri'
require 'net/http'
require 'json'
require 'notify_aws_cost/parse'

module NotifyAwsCost
  class Notify

    include Parse

    attr_reader :webhook_url, :parsed_url
    attr_accessor :name, :icon_url, :icon_emoji

    def initialize(args = {})
      raise "Set ENV['SLACK_WEBHOOK_URL']" if ENV['SLACK_WEBHOOK_URL'].nil? || ENV['SLACK_WEBHOOK_URL'].empty?
      @webhook_url        = ENV['SLACK_WEBHOOK_URL']
      @parsed_url         = URI.parse(@webhook_url)
      @name               = args.fetch(:name, nil)
      @icon_url           = args.fetch(:icon_url, nil)
      @icon_emoji         = args.fetch(:icon_emoji, nil)
      @warning_threshold  = args.fetch(:warning, nil)
      @critical_threshold = args.fetch(:critical, nil)
      @color              = "good"
      @cloudwatch         = AwsCost.new
    end

    def send
      each_service_hash = @cloudwatch.get_each_service_charege
      message, sum = each_service(each_service_hash)
      warning_critical_check(sum)
      payload = set_payload(message)
      post_payload(payload)
    end

    private

    def warning_critical_check(sum)
      # warningのみ設定されている場合
      if !@warning_threshold.nil? && @critical_threshold.nil?
        @color = "warning" if sum >= @warning_threshold.to_f
      end

      # criticalのみ設定されている場合
      if !@critical_threshold.nil? && @warning_threshold.nil?
        @color = "danger" if sum >= @critical_threshold.to_f
      end

      # warning, critical両方設定されている場合
      if !@warning_threshold.nil? && !@critical_threshold.nil?
        raise "warning must be less than critical" if @warning_threshold >= @critical_threshold
        if sum >= @critical_threshold
          @color = "danger"
        elsif sum >= @warning_threshold
          @color = "warning"
        end
      end
    end

    def make_pretext
      year = (Time.now - 86400).year
      month = (Time.now - 86400).month
      previous_day = (Time.now - 86400).day
      pretext = "#{year}/#{month}/01〜#{previous_day}日のAWS利用料金"
    end

    def set_payload(message)
      payload = {}
      payload[:username] = @name unless @name.nil?
      payload[:icon_url] = @icon_url unless @icon_url.nil?
      payload[:icon_emoji] = @icon_emoji unless @icon_emoji.nil?
      payload[:attachments] = [{color: @color, text: message, pretext: make_pretext}]
      payload
    end

    def post_payload(payload)
      begin
        conn = Net::HTTP.new(@parsed_url.host, @parsed_url.port)
        conn.use_ssl = true
        conn.verify_mode = OpenSSL::SSL::VERIFY_NONE
        response = conn.start do |http|
          http.open_timeout = 5
          http.read_timeout = 10
          request = Net::HTTP::Post.new(@parsed_url.path)
          request.set_form_data(payload: payload.to_json)
          http.request(request)
        end

        raise  "Failed to connect to #{@webhook_url}" unless response.is_a?(Net::HTTPSuccess)
      rescue => e
        puts "#{e.message}"
      end
    end

  end
end
