require_relative "dsl"
require_relative "yaml_io"
require "yaml"
require "fileutils"

include YamlIO

MODULES = [:IMBS, :IMAS, :QS]
ITEMS   = [:conf, :data, :bin]
GROUPS  = [:ps, :ns]

@operations = {}

def deploy(mod)
  raise "Unknown module - #{mod}. Current supports #{MODULES}" unless MODULES.include? mod
  @mod = mod.to_s.downcase
  yield if block_given?
end

def config(item)
  raise "Unknown item - #{item}. Current supports #{ITEMS}" unless ITEMS.include? item
  @item = item.to_s.downcase
  yield if block_given?
end

def group(name)
  raise "Unknown group - #{name}. Current supports #{GROUPS}" unless GROUPS.include? name
  @group = name.to_s.downcase
end

def load_platform_descriptor!
  raise "Platform descriptor not found - #{ARGV[0]}" unless File.exist? ARGV[0]
  @platform = ARGV[0][0..-4]
  load ARGV[0]
end

def define_operation(name)
  Kernel.send :define_method, name do |group_name, file_name, &action_bundle|
    group(group_name)
    path = "#@mod/#@item/#@group/#{file_name}"
    raise "SVN base file not found - #{path}" unless File.exist? path or name == :create

    action_bundle_chain =  @operations[path]? @operations[path] : []
    action_bundle_chain << action_bundle
    @operations[path] = action_bundle_chain
  end
end

[:create, :modify].each { |name| define_operation name }

load_platform_descriptor!

@operations.each_pair do |path, action_bundle_chain|
  dsl = Deployment::DSL.new
  dsl.content = yaml_from path

  action_bundle_chain.each do |action_bundle|
    dsl.instance_eval &action_bundle
  end

  file_name = path.split('/')[-1]
  output_path = "output/#@platform/#@mod/#@item/#{file_name}"

  yaml_to output_path, dsl.content
end
