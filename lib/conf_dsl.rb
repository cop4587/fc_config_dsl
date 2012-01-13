require_relative 'dsl'

module Deployment

  class ConfDSL < DSL

    def add(entry)
      @content.merge! stringify(entry)
    end

    def upd(entry)
      key = entry.keys[0].to_s
      raise "Entry to upd not found - #{key}" unless @content[key]
      @content[key] = entry.values[0].to_s
    end

    def del(key)
      key_s = key.to_s
      raise "Entry to del not found - #{key_s}" unless @content[key_s]
      @content.delete key_s
    end
  end
end
