require_relative 'dsl'

module Deployment

  class YamlDSL < DSL

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

    def load(file)
      @content = File.exist?(file) ? YAML.load_file(File.open file) : {}
    end

    def dump(path)
      dir = File.dirname path
      FileUtils.mkpath(dir) unless File.exist? dir
      File.open(path, 'w') { |f| YAML.dump(@content, f) }
    end
  end
end
