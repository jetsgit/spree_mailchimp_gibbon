# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_mailchimp_gibbon'
  s.version     = '0.0.8'
  s.summary     = 'Mail Chimp subscriptions for Spree using gibbon Mailchimp API wrapper'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Jerrold Thompson'
  s.email             = 'jet@whidbey.net'
  s.homepage          = 'https://github.com/bluehandtalking/spree_mailchimp_gibbon'


  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = true

  s.add_dependency 'spree_core', '~> 2.1.x'
  s.add_dependency 'gibbon',    '~> 1.0.4'
end
