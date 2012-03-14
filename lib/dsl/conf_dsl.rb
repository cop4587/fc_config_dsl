require_relative '../util/hash_util'

class Hash
  def has_at_sub?
    keys[0] =~ /^\d+$/
  end

  def value_of(name)
    return self[name] if self.key?(name)
    values.each do |value|
      return value.value_of(name) if value.is_a? Hash
    end
    return nil
  end
end

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

      @upd_stack = []
      @upd_stack.push content
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
      return @upd_stack.last[entry.keys[0].to_s] = entry.values[0].to_s if block.nil?
      @upd_stack.push @upd_stack.last[entry.to_s]
      block.call
      @upd_stack.pop
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
      nesting_levels = line.scan(/^(\[\.*)/)[0][0].size - 1  # e.g., '[' = 0, '[.' = 1, '[..' = 2
      current_hash = {}

      if is_a_at_sub?(line)
        if first_of_at_sub?(line)
          @at_sub_name = key_of(line)[1..-1]
          @at_sub_counter = (0..lines.join.scan(key_of(line)).size - 1).to_a

          hash_at(nesting_levels, root_hash)[@at_sub_name] = current_hash

          at_sub_index = @at_sub_counter.shift
          a_at_sub = {}
          current_hash[at_sub_index.to_s] = a_at_sub
        else
          return if @at_sub_counter.empty?
          at_sub_index = @at_sub_counter.shift
          a_at_sub = {}
          root_hash.value_of(@at_sub_name)[at_sub_index.to_s] = a_at_sub
        end

        load_lines(lines[1..-1], root_hash, a_at_sub)
      else
        hash_at(nesting_levels, root_hash)[key_of(line)] = current_hash
        load_lines(lines[1..-1], root_hash, current_hash)
      end
    end


    def self.first_of_at_sub?(line)
      @at_sub_name != key_of(line)[1..-1]
    end

    def self.is_a_at_sub?(line)
      key_of(line).start_with?('@')
    end

    def self.load_entry(lines, root_hash, current_hash)
      key, value = lines[0].strip.split SEPARATOR
      current_hash[key] = value
      load_lines(lines[1..-1], root_hash, current_hash)
    end

    def self.hash_at(nesting_levels, root_hash)
      return root_hash if nesting_levels == 0
      return root_hash.values[-1] if nesting_levels == 1

      hash_nested = "values[-1]" + (".values[-1]" * (nesting_levels - 1))
      root_hash.instance_eval hash_nested
    end

    def self.key_of(line)
      prefix = line.scan /^(\[\.*)/
      line[prefix[0][0].size..-2]
    end

    def self.dump(content, file, level=0)
      content.each_pair do |name, body|
        next dump_entry(name, body, file) unless body.is_a? Hash
        dump_body(name, body, file, level)
      end
    end

    def self.dump_body(name, body, file, level)
      if body.has_at_sub? and Integer(body.keys[0]) == 0
        @at_sub_name, @at_sub_level, @at_sub_count  = name, level, body.keys.size
        dump(body, file, level)
      else
        if is_a_at_sub_item?(name)
          dump_array(@at_sub_name, @at_sub_level, file)
        else
          dump_feature(name, level, file)
        end
        dump(body, file, level+1)
      end
    end

    def self.is_a_at_sub_item?(name)
      name =~ /^\d+$/ and Integer(name) < @at_sub_count
    end

    private

    def self.dump_feature(name, level, file)
      file.puts "[#{'.'*level}#{name}]"
    end

    def self.dump_array(name, level, file)
      file.puts "[#{'.'*level}@#{name}]"
    end

    def self.dump_entry(name, body, file)
      file.puts "#{name}#{SEPARATOR}#{body}"
    end
  end
end
