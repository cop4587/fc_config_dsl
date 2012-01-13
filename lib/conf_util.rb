module ConfUtil
  def conf_from(path)
    File.exist?(path) ? CONF.load_file(File.open path) : {}
  end

  def conf_to(path, content)

  end

  class Conf

    CONF_SEPARATOR  = ' : '

    def self.load_file(file)
      result = {}
      file.each_line do |line|
        key, value = line.strip.split CONF_SEPARATOR
        result[key] = value
      end
      result
    end

    def self.dump(content, file)
      content.each_pair do |key, value|
        file.puts "#{key} : #{value}"
      end
    end
  end
end