# frozen_string_literal: true

require_relative 'lib/at_coder_vc_friends/version'

Gem::Specification.new do |spec|
  spec.name          = 'at_coder_vc_friends'
  spec.version       = AtCoderVcFriends::VERSION
  spec.authors       = ['nejiko96']
  spec.email         = ['nejiko2006@gmail.com']

  spec.summary       = 'AtCoder Virtual Contest support tool'
  spec.description   = <<-DESCRIPTION
    AtCoder Virtual Contest support tool
    - generate source template
    - generate test data from sample input/output
    - run tests
    - submit code
  DESCRIPTION
  spec.homepage      = 'https://github.com/nejiko96/at_coder_vc_friends'
  spec.license       = 'MIT'
  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem
  # that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'source_code_uri' => spec.homepage,
    'changelog_uri' => spec.homepage + '/blob/master/CHANGELOG.md'
  }

  # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.add_dependency 'at_coder_friends', '~> 0.6.6'
end
