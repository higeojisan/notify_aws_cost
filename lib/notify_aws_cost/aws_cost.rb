require 'aws-sdk-cloudwatch'

module NotifyAwsCost
  class AwsCost
    NAME_SPACE = "AWS/Billing"
    METRIC_NAME = "EstimatedCharges"
    ESTIMATE_PERIOD = 86400
    STRFTIME_PARAM = "%Y-%m-%dT%H%M%SZ"

    def initialize
      @client = Aws::CloudWatch::Client.new
      @end_time = Time.utc((Time.now - 86400).year, (Time.now - 86400).month, (Time.now - 86400).day, 15, 0, 0, 0).strftime(STRFTIME_PARAM)
      @start_time = Time.utc((Time.now - 86400 * 2).year, (Time.now - 86400 * 2).month, (Time.now - 86400 * 2).day, 15, 0, 0, 0).strftime(STRFTIME_PARAM)
    end

    def get_each_service_charege
      cw_metric = Aws::CloudWatch::Metric.new(NAME_SPACE, METRIC_NAME, {client: @client})
      lists = get_service_list
      results = {}
      lists.metrics.each do |metric|
        dimensions = []
        service_name = nil
        metric.dimensions.each do |dimension|
          service_name = dimension.value if dimension.name == "ServiceName"
          dimensions << {name: dimension.name, value: dimension.value}
        end
        resp = cw_metric.get_statistics({
          dimensions: dimensions,
          start_time: @start_time,
          end_time: @end_time,
          period: ESTIMATE_PERIOD,
          statistics: ["Maximum"],
        })
        results[service_name.to_sym] = resp unless service_name.nil?
      end
      results
    end

    private

    def get_service_list
      resp = @client.list_metrics({
        namespace: NAME_SPACE,
        metric_name: METRIC_NAME,
        dimensions: [
          {
            name: "Currency",
            value: "USD",
          },
          {
            name: "ServiceName"
          },
        ],
      })
      resp
    end
  end
end
