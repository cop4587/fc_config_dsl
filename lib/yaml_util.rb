module YamlUtil
  def from(path)
    File.exist?(path) ? YAML.load_file(File.open path) : {}
  end

  def dump(content, path)
    dir = File.dirname path
    FileUtils.mkpath(dir) unless File.exist? dir
    File.open(path, 'w') { |f| YAML.dump(content, f) }
  end
end