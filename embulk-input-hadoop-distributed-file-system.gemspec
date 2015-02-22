
Gem::Specification.new do |spec|
  spec.name          = "embulk-input-hadoop-distributed-file-system"
  spec.version       = "0.1.0"
  spec.authors       = ["takahiro.nakayama"]
  spec.summary       = "Hadoop Distributed File System input plugin for Embulk"
  spec.description   = "Hadoop Distributed File System input plugin is an Embulk plugin that loads records from Hadoop Distributed File System so that any output plugins can receive the records. Search the output plugins by 'embulk-output' keyword."
  spec.email         = ["takahiro.nakayama@dena.com"]
  spec.licenses      = ["MIT"]
  # TODO: spec.homepage      = "https://github.com/takahiro.nakayama/embulk-input-hadoop-distributed-file-system"

  spec.files         = `git ls-files`.split("\n") + Dir["classpath/*.jar"]
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ["lib"]

  #spec.add_dependency 'YOUR_GEM_DEPENDENCY', ['~> YOUR_GEM_DEPENDENCY_VERSION']
  spec.add_development_dependency 'bundler', ['~> 1.0']
  spec.add_development_dependency 'rake', ['>= 10.0']

  spec.add_dependency 'hdfs_jruby'
end
