module ConfUtil
  def from(path)
    File.exist?(path) ? Conf.load_file(File.open path) : {}
  end

  def dump(content, path)
    dir = File.dirname path
    FileUtils.mkpath(dir) unless File.exist? dir
    File.open(path, 'w') { |f| Conf.dump(content, f) }
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