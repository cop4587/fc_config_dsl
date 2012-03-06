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
      lines = file.readlines
      content = {}
      load_lines(lines, content, content)
      content
    end

    def self.load_lines(lines, root_hash, current_hash)
      lines[0].start_with?('[')?
          load_feature(lines, root_hash) : load_entry(lines, root_hash, current_hash) unless lines.empty?
    end

    def self.load_feature(lines, root_hash)
      line = lines[0].strip
      nesting_levels = line.scan(/^(\[\.*)/)[0][0].size - 1  # '[' = 0, '[.' = 1, '[..' = 2
      current_hash = {}
      hash_at(nesting_levels, root_hash)[key_of line] = current_hash
      load_lines(lines[1..-1], root_hash, current_hash)
    end

    def self.hash_at(nesting_levels, root_hash)
      return root_hash if nesting_levels == 0
      return root_hash.values[-1] if nesting_levels == 1

      hash_nested = "values[-1]" + (".values[-1]" * (nesting_levels - 1))
      root_hash.instance_eval hash_nested
    end

    def self.load_entry(lines, root_hash, current_hash)
      key, value = lines[0].strip.split SEPARATOR
      current_hash[key] = value
      load_lines(lines[1..-1], root_hash, current_hash)
    end

    def self.key_of(line)
      prefix = line.scan /^(\[\.*)/
      line[prefix[0][0].size..-2]
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
              dump entries, level+1, file
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
