Gem::Specification.new do |s|
  s.name        = 'device_api'
  s.version     = '0.1.3'
  s.date        = '2014-09-01'
  s.summary     = 'Physical Device Management API'
  s.description = 'A common interface for physical devices'
  s.authors     = ['David Buckhurst']
  s.email       = 'david.buckhurst@bbc.co.uk'
  s.files       = `git ls-files`.split "\n"
  s.homepage    = 'https://github.com/bbc-test/device_api'
  s.license     = 'MIT'
  s.add_development_dependency 'rspec'
end
