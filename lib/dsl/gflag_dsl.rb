module Deployment

  class GflagDSL

    attr_accessor :content

    def add(entry)
      case entry.values[0].to_s
        when 'yes'
          @content << entry.keys[0].to_s
        when 'no'
          @content << "no#{entry.keys[0].to_s}"
      end
    end

    def upd(entry)
      del(entry.keys[0])
      add(entry)
    end

    def del(key)
      flag = key.to_s
      noflag = "no#{flag}"
      raise "Gflag not found - #{flag}" unless @content.include? flag or @content.include? noflag
      @content.delete   flag
      @content.delete noflag
    end

    def load(file)
      @content = File.exist?(file) ? Gflag.load_file(File.open file) : []
    end

    def dump(path)
      dir = File.dirname path
      FileUtils.mkpath(dir) unless File.exist? dir
      File.open(path, 'w') { |f| Gflag.dump(@content, f) }
    end
  end

  class Gflag

    PREFIX = '--'

    def self.load_file(file)
      result = []
      file.each_line do |line|
        result << line.strip[PREFIX.size..-1]
      end
      result
    end

    def self.dump(content, file)
      content.each do |line|
        file.puts "#{PREFIX}#{line}"
      end
    end
  end
end