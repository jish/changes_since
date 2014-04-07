Gem::Specification.new do |s|
  s.name        = "changes_since"
  s.version     = "0.0.4"
  s.summary     = "Git Changes since a tag"
  s.date        = "2014-04-07"
  s.description = "Shows you all the merged pull requests since a certain git tag in a nice format"
  s.authors     = ["Ashwin Hegde"]
  s.email       = ["ahegde@zendesk.com"]
  s.files       = Dir['lib/**/*']
  s.test_files  = Dir['test/**/*']
  s.homepage    = 'http://rubygems.org/gems/changes_since'
  s.license     = 'MIT'
  s.add_dependency(%q<git>)
end
