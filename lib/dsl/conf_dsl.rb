require_relative '../util/hash_util'

module Deployment

  module AddDSL
    def _(entry, &block)
      add_sub entry, block
    end
  end

  module UpdDSL
    def _(entry, &block)
      upd_sub entry, block
    end
  end

  class ConfDSL
    include HashUtil

    def initialize
      @stack = []
      @stack.push Hash.new
      @current = content
    end

    def content
      @stack.first
    end

    def content=(given)
      content.clear
      content.merge! given
    end

    def add(entry, &block)
      extend AddDSL
      add_sub entry, block
    end

    def upd(entry, &block)
      extend UpdDSL
      upd_sub entry, block
    end



    def del(key)
      key_s = key.to_s
      raise "Entry to del not found - #{key_s}" unless content[key_s]
      @stack.first.delete key_s
    end

    def load(file)
      content = File.exist?(file) ? Conf.load_file(File.open file) : {}
    end

    def dump(path)
      dir = File.dirname path
      FileUtils.mkpath(dir) unless File.exist? dir
      File.open(path, 'w') { |f| Conf.dump(content, f) }
    end

    private

    def add_sub(entry, block)
      return @stack.last.merge!(stringify(entry)) if block.nil?
      hash = {}
      @stack.last[entry.to_s] = hash
      @stack.push hash
      block.call
      @stack.pop
    end

    def upd_sub(entry, block)
      return @current[entry.keys[0].to_s] = entry.values[0].to_s if block.nil?
      @current = @current[entry.to_s]
      block.call
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
          load_feature(lines, root_hash)
            : load_entry(lines, root_hash, current_hash) unless lines.empty?
    end

    def self.load_feature(lines, root_hash)
      line = lines[0].strip
      nesting_levels = line.scan(/^(\[\.*)/)[0][0].size - 1  # '[' = 0, '[.' = 1, '[..' = 2
      current_hash = {}

      key_of_line = key_of line
      if key_of_line.start_with?('@')

      end


      hash_at(nesting_levels, root_hash)[key_of_line] = current_hash
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

    def self.dump(content, file, level=0)
      content.each_pair do |name, body|
        if has_sub_feature? body
          feature name, level, file
          dump body, file, level+1
        elsif has_sub_array? body
          body.each do |at_sub|
            at_sub.each_pair do |index, entries|
              array name, level, file
              dump entries, file, level+1
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
