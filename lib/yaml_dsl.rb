module Deployment

  class YamlDSL

    attr_accessor :content

    def initialize
      @elements = {}
    end

    def add(key, &block)
      @elements.clear
      block.call

      entry = {}
      entry[key.to_s] = @elements.clone
      @content.merge! entry
    end

    def upd(key, &block)
      key_s = key.to_s
      raise "Entry to upd not found - #{key_s}" unless @content[key_s]
      @elements.clear
      block.call

      @elements.each_pair do |element_k, element_v|
        element_k_s = element_k.to_s
        raise "Element to upd not found - #{element_k_s} " unless @content[key_s][element_k_s]
        @content[key_s][element_k_s] = element_v
      end
    end

    def del(key)
      key_s = key.to_s
      raise "Entry to del not found - #{key_s}" unless @content[key_s]
      @content.delete key_s
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
