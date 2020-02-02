# frozen_string_literal: true

require 'at_coder_friends'

module AtCoderVcFriends
  # Holds applicaion global information
  # - command line options
  # - target path
  # - configuration
  # - application modules
  class Context < AtCoderFriends::Context
    def initialize(options, path)
      @options = options
      @path_info = AtCoderVcFriends::PathInfo.new(File.expand_path(path))
    end

    def scraping_agent
      @scraping_agent ||= AtCoderVcFriends::Scraping::Agent.new(self)
    end
  end
end
