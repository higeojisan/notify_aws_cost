module NotifyAwsCost
  module Parse

    def each_service(each_service_hash)
      result = ""
      sum = 0
      each_service_hash.each do |key, val|
        if val.datapoints == []
          result += "#{key}: N/A\n\n"
        else
          result += "#{key}: $#{val.datapoints[0].maximum}\n\n"
          sum += val.datapoints[0].maximum
        end
      end
      result += "============================\n\n"
      result += "Total: $#{sum}"
      return result, sum
    end

    module_function :each_service

  end
end
