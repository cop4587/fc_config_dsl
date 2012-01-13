module Deployment
  class DSL

    attr_accessor :content
    
    def stringify(hash)
      result = {}
      result[hash.keys[0].to_s] = hash.values[0].to_s
      result
    end
  end
end