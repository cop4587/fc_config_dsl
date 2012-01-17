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

    def load(file)
      @content = File.exist?(file) ? Conf.load_file(File.open file) : {}
    end

    def dump(path)
      dir = File.dirname path
      FileUtils.mkpath(dir) unless File.exist? dir
      File.open(path, 'w') { |f| Conf.dump(@content, f) }
    end


  end

  class Conf

    SEPARATOR  = ' : '

    def self.load_file(file)
      result = {}
      file.each_line do |line|
        key, value = line.strip.split SEPARATOR
        result[key] = value
      end
      result
    end

    def self.dump(content, file)
      content.each_pair do |key, value|
        file.puts "#{key}#{SEPARATOR}#{value}"
      end
    end
  end
end
