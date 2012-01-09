module Deployment

  class DSL

    attr_accessor :content

    def initialize
      @elements = {}
    end

    def add(key, &block)
      @elements.clear
      block.call

      entry = {}
      entry[key] = @elements.clone
      @content.merge! entry
    end

    def upd(key, &block)
      raise "Entry not found - #{key}" unless @content[key]
      @elements.clear
      block.call

      @elements.each_pair do |element_k, element_v|
        raise "Element not found - #{element_k} " unless @content[key][element_k]
        @content[key][element_k] = element_v
      end
    end

    def del(key)
      raise "Entry not found - #{key}" unless @content[key]
      @content.delete key
    end

    def _(element)
      @elements.merge! stringify(element)
    end

    private

    def stringify(hash)
      result = {}
      result[hash.keys[0].to_s] = hash.values[0].to_s
      result
    end
  end
end # module Deployment
