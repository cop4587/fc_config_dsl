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

    def self.dump(content, level=0, file)
      content.each_pair do |name, body|
        if has_sub_feature? body
          feature name, level, file
          dump body, level+1, file
        elsif has_sub_array? body
          body.each do |at_sub|
            at_sub.each_pair do |index, entries|
              array name, level, file
              entries.each_pair do |key, val|
                entry key, val, file
              end
            end
          end
        else
          entry name, body, file
        end
      end
    end

    private

    def self.has_sub_feature?(body)
      body.is_a? Hash
    end

    def self.has_sub_array?(body)
      body.is_a? Array
    end

    def self.feature(name, level, file)
      file.puts "[#{'.'*level}#{name}]"
    end

    def self.array(name, level, file)
      file.puts "[#{'.'*level}@#{name}]"
    end

    def self.entry(name, body, file)
      file.puts "#{name}#{SEPARATOR}#{body}"
    end
  end
end
