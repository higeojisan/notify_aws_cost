require 'aws-sdk-cloudwatch'

module NotifyAwsCost
  class AwsCost
    NAME_SPACE = "AWS/Billing"
    METRIC_NAME = "EstimatedCharges"
    ESTIMATE_PERIOD = 86400

    def initialize
      @client = Aws::CloudWatch::Client.new
    end

    def get_each_service_charege
      cw_metric = Aws::CloudWatch::Metric.new(NAME_SPACE, METRIC_NAME, {client: @client})
      lists = get_service_list
      lists.metrics.each do |metric|
        dimensions = []
        metric.dimensions.each do |dimension|
          dimensions << {name: dimension.name, value: dimension.value}
        end
        resp = cw_metric.get_statistics({
          dimensions: dimensions,
          start_time: "2018-11-15T00:09:00Z",
          end_time: "2018-11-16T00:09:00Z",
          period: ESTIMATE_PERIOD,
          statistics: ["Maximum"],
        })
        p resp
      end
    end

    def get_total_charge
      metric = Aws::CloudWatch::Metric.new(NAME_SPACE, METRIC_NAME, {client: @client})
      resp = metric.get_statistics({
        dimensions: [
          {
          name: "Currency",
          value: "USD",
          },
        ],
        start_time: "2018-11-15T00:09:00Z",
        end_time: "2018-11-16T00:09:00Z",
        period: ESTIMATE_PERIOD,
        statistics: ["Maximum"],
      })
      p resp
    end

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
