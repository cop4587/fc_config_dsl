require_relative "dsl"
require_relative "yaml_io"
require "yaml"
require "fileutils"

include YamlIO

@operations = {}

def deploy(mod)
  @mod = mod.to_s.downcase
  yield if block_given?
end

def config(item)
  @item = item.to_s.downcase
  yield if block_given?
end

def define_operation(name)
  Kernel.send :define_method, name do |group, file, &action_bundle|
    path = "#{@mod}/#{@item}/#{group.to_s.downcase}/#{file}"
    raise "SVN base file not found - #{path}" unless File.exist? path or name == :create

    action_bundle_chain =  @operations[path]? @operations[path] : []
    action_bundle_chain << action_bundle
    @operations[path] = action_bundle_chain
  end
end

[:create, :modify].each { |name| define_operation name }

deploy_descriptor = ARGV[0]
raise "Deployment descriptor file not exist - #{deploy_descriptor}" unless File.exist? deploy_descriptor
load deploy_descriptor

@operations.each_pair do |path, action_bundle_chain|
  dsl = Deployment::DSL.new
  dsl.content = yaml_from path

  action_bundle_chain.each do |action_bundle|
    dsl.instance_eval &action_bundle
  end

  yaml_to "output/#{ARGV[0][0..-4]}/#{path}", dsl.content
end
