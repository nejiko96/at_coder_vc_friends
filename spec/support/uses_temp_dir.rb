# frozen_string_literal: true

shared_context :uses_temp_dir do
  around do |example|
    Dir.mktmpdir('rspec-') do |dir|
      @temp_dir = dir
      example.run
    end
  end

  attr_reader :temp_dir
end
