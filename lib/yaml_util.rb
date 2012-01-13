module YamlUtil
  def yaml_from(path)
    File.exist?(path) ? YAML.load_file(File.open path) : {}
  end

  def yaml_to(path, content)
    dir = File.dirname path
    FileUtils.mkpath(dir) unless File.exist? dir
    File.open(path, 'w') { |f| YAML.dump(content, f) }
  end
end