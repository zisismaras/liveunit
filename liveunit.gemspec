Gem::Specification.new do |s|
  s.name        = 'liveunit'
  s.version     = '0.0.1'
  s.date        = '2015-06-05'
  s.required_ruby_version = '>= 2.0.0'
  s.summary     = "Example implementation to test my experiment on live unit testing. "
  s.description = <<EOF
Example implementation to test my experiment on live unit testing.
Make sure to check the blog post here : http://zisismaras.me/general/2015/05/01/exploring-live-unit-tests.html
and the github repo.
EOF

  s.files       = `git ls-files`.split("\n")
  s.add_development_dependency 'rspec', '~> 3.2.0'
  s.add_runtime_dependency 'after_do', '~> 0.3.1'
  s.add_runtime_dependency 'minitest', '~> 5.7.0'

  s.authors = ["Zisis Maras"]
  s.email = 'contact@zisismaras.me'
  s.homepage = 'https://github.com/zisismaras/liveunit'
  s.license = 'MIT'
end
