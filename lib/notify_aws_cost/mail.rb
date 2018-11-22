require 'mail'
require 'notify_aws_cost/parse'

module NotifyAwsCost
  class Mail
    SUBJECT = 'NOTIFY AWS COST'

    include Parse

    def initialize(args = {})
      raise "Set ENV['NOTIFY_MAIL_ADDR']" if ENV['NOTIFY_MAIL_ADDR'].nil? || ENV['NOTIFY_MAIL_ADDR'].empty?
      raise "Set ENV['GMAIL_PASSWORD']" if ENV['GMAIL_PASSWORD'].nil? || ENV['GMAIL_PASSWORD'].empty?
      @cloudwatch   = AwsCost.new
      @mail_options = {
        address:              'smtp.gmail.com',
        port:                 587,
        user:                 ENV['NOTIFY_MAIL_ADDR'],
        password:             ENV['GMAIL_PASSWORD'],
        authentication:       :plain,
        enable_starttls_auto: true,
      }
    end

    def send
      #each_service_hash = @cloudwatch.get_each_service_charege
      #message, sum = each_service(each_service_hash)
      send_mail
    end

    private

    def make_pretext
      year = (Time.now - 86400).year
      month = (Time.now - 86400).month
      previous_day = (Time.now - 86400).day
      pretext = "#{year}/#{month}/01〜#{previous_day}日のAWS利用料金"
    end

    def send_mail
      mail = Mail.deliver do
        from    'notify_aws_cost@example.com'
        to      ENV['NOTIFY_MAIL_ADDR']
        subject SUBJECT
        body    'テスト'
      end
      mail.charset = 'utf-8'
      mail.deliver_method(:smtp, @mail_options)
      mail.deliver
    end

  end
end
