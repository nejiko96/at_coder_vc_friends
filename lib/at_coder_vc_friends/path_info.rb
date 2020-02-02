# frozen_string_literal: true

require 'at_coder_friends'

module AtCoderVcFriends
  # holds target path information
  class PathInfo < AtCoderFriends::PathInfo
    def contest_name
      q = components[-1]
      q.split('#')[0]
    end

    def components
      @dir, prg = File.split(path)
      base, ext = prg.split('.')
      q = base.gsub(/_[^#_]+\z/, '')
      [path, dir, prg, base, ext, q]
    end
  end
end
