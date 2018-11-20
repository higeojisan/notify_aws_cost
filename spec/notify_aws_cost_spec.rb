RSpec.describe NotifyAwsCost do
  it "has a version number" do
    expect(NotifyAwsCost::VERSION).not_to be nil
  end

  #it "does something useful" do
  #  expect(false).to eq(true)
  #end
end

 RSpec.describe NotifyAwsCost::AwsCost do


  context "get_service_list" do
    it "normal" do
      correct_hash = {
        metrics: [
          {
            namespace: "AWS/Billing",
            metric_name: "EstimatedCharges",
            dimensions: [
              {
                name: "ServiceName",
                value: "AmazonSNS",
              },
              {
                name: "Currency",
                value: "USD",
              },
            ]
          }
        ]
      }
      Aws.config[:cloudwatch] = {
        stub_responses: {
          list_metrics: correct_hash
        }
      }
      aws_cost = NotifyAwsCost::AwsCost.new
      expect(aws_cost.send(:get_service_list).to_h).to eq correct_hash
    end
  end
 end
