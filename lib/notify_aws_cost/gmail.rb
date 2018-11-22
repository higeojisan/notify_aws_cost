require 'mail'
require 'notify_aws_cost/parse'

module NotifyAwsCost
  class Gmail
    SUBJECT = 'NOTIFY AWS COST'
    CHARSET = 'utf-8'
    GMAIL_SERVER = "smtp.gmail.com"

    include Parse

    def initialize(args = {})
      raise "Set ENV['NOTIFY_MAIL_ADDR']" if ENV['NOTIFY_MAIL_ADDR'].nil? || ENV['NOTIFY_MAIL_ADDR'].empty?
      raise "Set ENV['GMAIL_ADDR']" if ENV['GMAIL_ADDR'].nil? || ENV['GMAIL_ADDR'].empty?
      raise "Set ENV['GMAIL_PASSWORD']" if ENV['GMAIL_PASSWORD'].nil? || ENV['GMAIL_PASSWORD'].empty?
      @cloudwatch   = AwsCost.new
      @mail_options = {
        address:              GMAIL_SERVER,
        port:                 587,
        user_name:            ENV['GMAIL_ADDR'],
        password:             ENV['GMAIL_PASSWORD'],
        authentication:       :plain,
        enable_starttls_auto: true,
      }
    end

    def send
      each_service_hash = @cloudwatch.get_each_service_charege
      result, sum = each_service(each_service_hash)
      message = make_pretext + "˜\n\n" + result
      send_mail(message)
    end

    private

    def make_pretext
      year = (Time.now - 86400).year
      month = (Time.now - 86400).month
      previous_day = (Time.now - 86400).day
      pretext = "#{year}/#{month}/01〜#{previous_day}日のAWS利用料金"
    end

    def send_mail(message)
      mail = Mail.new do
        from    ENV['GMAIL_ADDR']
        to      ENV['NOTIFY_MAIL_ADDR']
        subject SUBJECT
        body    message
      end
      mail.charset = CHARSET
      mail.delivery_method(:smtp, @mail_options)
      mail.deliver
    end

  end
end
