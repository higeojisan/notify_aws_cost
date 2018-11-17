module NotifyAwsCost
  class Parse

    def initialize
    end

    def each_service(each_service_hash)
      result = ""
      each_service_hash.each do |key, val|
        if val.datapoints == []
          result += "#{key}: N/A\n\n"
        else
          result += "#{key}: $#{val.datapoints[0].maximum}USD\n\n"
        end
      end
      result
    end

  end
end
