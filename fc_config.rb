require_relative "dsl"
require_relative "yaml_io"
require "yaml"
require "fileutils"

@operations = {}

def define_operation(name)
  Kernel.send :define_method, name do |platform, file, &actions|
    path = "#{platform.to_s}/#{file}"
    @operations[path] = actions
  end
end

[:create, :modify].each { |name| define_operation name }

deploy_descriptor = ARGV[0]
raise "File not exist - #{deploy_descriptor}" unless File.exist? deploy_descriptor 
load deploy_descriptor 

@operations.each_pair do |path, actions|
  yaml = YamlIO.new
  dsl = DSL.new
  dsl.content = yaml.from path
  dsl.instance_eval &actions
  yaml.to "output/#{path}", dsl.content
end
