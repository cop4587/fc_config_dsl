Gem::Specification.new do |spec|
  spec.name = 'fc_config'
  spec.summary = 'A tool for generating FC IM deployment configuration.'
  spec.description = %(
    This tool generates deployment configuration for module IMAS, IMBS, QS,
      on configuration items conf, data and bin, of platform group ns or ps.
    It supports both YAML and conf format.)
  spec.author = 'Ma Bo (PMO)'
  spec.email = 'mabo01@baidu.com'
  spec.files = Dir['lib/**/*.rb', 'bin/fc_config']

  spec.executables = ["fc_config"]
  spec.default_executable = %q{fc_config}

  spec.version = '0.0.6'
end