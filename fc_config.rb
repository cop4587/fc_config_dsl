require_relative "dsl"

require "yaml"

@modifications = {}
@creations = {}

def create(platform, file, &actions)
  path = "#{platform.to_s}/#{file}"
  @creations[path] = actions
end

def modify(platform, file, &actions)
  path = "#{platform.to_s}/#{file}"
  @modifications[path] = actions
end

def read_from(path)
  YAML.load_file(File.open(path))
end

def write_to(path, content)
  File.open(path, 'w') do |f|
    YAML.dump(content, f)
  end
end

deploy_descriptor = ARGV[0]
raise "File not exist - #{deploy_descriptor}" unless File.exist? deploy_descriptor 
load deploy_descriptor 

@modifications.each_pair do |path, actions|
  dsl = DSL.new
  
  content = read_from path
  
  puts "content = #{content}"
  
  dsl.content = content
  dsl.instance_eval &actions
  write_to path, dsl.content
end
