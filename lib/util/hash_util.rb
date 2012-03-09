module Deployment

  module HashUtil

    def stringify(hash)
      result = {}
      hash.each_pair do |k,v|
        result[k.to_s] = v.to_s
      end
      result
    end
  end
end
