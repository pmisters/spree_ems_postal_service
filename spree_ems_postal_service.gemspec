Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_ems_postal_service'
  s.version     = '0.0.1'
  s.summary     = 'Shipping calculator for Sri Lanka EMS Service'
  s.description = 'Weight based Shipping calculator for Sri Lanka EMS Service'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Pavel Musolin'
  s.email             = 'pavel@harizma.lv'

  s.files        = Dir['lib/**/*', 'app/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = true

  s.add_dependency('spree_core', '>= 0.30.0')
end