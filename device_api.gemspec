Gem::Specification.new do |s|
  s.name        = 'device_api'
  s.version     = '1.0.1'
  s.date        =  Time.now.strftime("%Y-%m-%d")
  s.summary     = 'Physical Device Management API'
  s.description = 'A common interface for physical devices'
  s.authors     = ['BBC', 'David Buckhurst']
  s.email       = 'david.buckhurst@bbc.co.uk'
  s.files       = `git ls-files`.split "\n"
  s.homepage    = 'https://github.com/bbc/device_api'
  s.license     = 'MIT'
  s.add_development_dependency 'rspec'
end
