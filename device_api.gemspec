Gem::Specification.new do |s|
  s.name        = 'device_api'
  s.version     = '0.1.0.pre2'
  s.date        = '2014-07-05'
  s.summary     = 'Physical Device Management API'
  s.description = 'A common interface for physical devices'
  s.authors     = ['David Buckhurst']
  s.email       = 'david.buckhurst@bbc.co.uk'
  s.files       = Dir['README.md', 'lib/**/*.rb' ]
  s.homepage    = 'https://github.com/bbc-test/device_api'
  s.license     = 'MIT'
  s.add_development_dependency 'rspec'
end
