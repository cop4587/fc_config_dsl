class YamlIO
  def from(path)
    File.exist?(path) ? YAML.load_file(File.open path) : {}
  end

  def to(path, content)
    FileUtils.mkpath(File.dirname path) unless File.exist? path
    File.open(path, 'w') { |f| YAML.dump(content, f) }
  end
end