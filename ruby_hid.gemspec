Gem::Specification.new do |s|
  s.name        = 'ruby_hid'
  s.version     = '0.0.2'
  s.date        = '2016-03-24'
  s.summary     = 'HID game controller support for Ruby in Linux'
  s.description = 'HID device observer library for Ruby applications. Currently only ubuntu Linux distributions.'
  s.authors     = ['Andrew Faraday']
  s.email       = 'andrewfaraday@hotmail.co.uk'
  s.files       = Dir.glob("lib/**/*") + 
                  ['lib/ruby_hid.rb'] +
                  %w{ LICENCE README.md }
  s.homepage    = 'https://github.com/AJFaraday/ruby-hid'
  s.license     = 'MIT'
  # Untested on earlier ruby versions, will probably work there too.
  s.required_ruby_version = '>= 2.0.0'
end
