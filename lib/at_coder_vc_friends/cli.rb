# frozen_string_literal: true

require 'optparse'
require 'at_coder_friends'

module AtCoderVcFriends
  # command line interface
  class CLI
    EXITING_OPTIONS = %i[version].freeze
    OPTION_BANNER   =
      <<~TEXT
        Usage:
          at_coder_vc_friends setup        path/to/contest url # setup contest folder
          at_coder_vc_friends test-one     path/to/src         # run 1st test case
          at_coder_vc_friends test-all     path/to/src         # run all test cases
          at_coder_vc_friends submit       path/to/src         # submit source code
          at_coder_vc_friends check-and-go path/to/src         # submit source if all tests passed
        Options:
      TEXT
    STATUS_SUCCESS  = 0
    STATUS_ERROR    = 1

    attr_reader :ctx

    def run(args = ARGV)
      parse_options!(args)
      handle_exiting_option
      raise AtCoderFriends::ParamError, 'command or path is not specified.' if args.size < 2

      exec_command(*args)
      STATUS_SUCCESS
    rescue AtCoderFriends::ParamError => e
      warn @usage
      warn "error: #{e.message}"
      STATUS_ERROR
    rescue AtCoderFriends::AppError => e
      warn e.message
      STATUS_ERROR
    rescue SystemExit => e
      e.status
    end

    def parse_options!(args)
      op = OptionParser.new do |opts|
        opts.banner = OPTION_BANNER
        opts.on('-v', '--version', 'Display version.') do
          @options[:version] = true
        end
        opts.on('-d', '--debug', 'Display debug info.') do
          @options[:debug] = true
        end
      end
      @usage = op.to_s
      @options = {}
      op.parse!(args)
    rescue OptionParser::InvalidOption => e
      raise AtCoderFriends::ParamError, e.message
    end

    def handle_exiting_option
      return unless EXITING_OPTIONS.any? { |o| @options.key? o }

      puts AtCoderFriends::VERSION if @options[:version]
      exit STATUS_SUCCESS
    end

    def exec_command(command, path, *args)
      @ctx = Context.new(@options, path)
      case command
      when 'setup'
        setup(*args)
      when 'test-one'
        test_one(*args)
      when 'test-all'
        test_all
      when 'submit'
        submit
      when 'check-and-go'
        check_and_go
      else
        raise AtCoderFriends::ParamError, "unknown command: #{command}"
      end
      ctx.post_process
    end

    def setup(url)
      path = ctx.path
      raise AtCoderFriends::AppError, "#{path} is not empty." \
        if Dir.exist?(path) && !Dir["#{path}/*"].empty?

      ctx.scraping_agent.fetch_all_vc(url) do |pbm|
        AtCoderFriends::Parser::Main.process(pbm)
        ctx.generator.process(pbm)
        ctx.emitter.emit(pbm)
      end
    end

    def test_one(id = '001')
      ctx.sample_test_runner.test_one(id)
    end

    def test_all
      ctx.sample_test_runner.test_all
      ctx.verifier.verify
    end

    def submit
      vf = ctx.verifier
      raise AtCoderFriends::AppError, "#{vf.file} has not been tested." unless vf.verified?

      ctx.scraping_agent.submit
      vf.unverify
    end

    def check_and_go
      vf = ctx.verifier
      if ctx.sample_test_runner.test_all
        # submit automatically
        ctx.scraping_agent.submit
        vf.unverify
      else
        # enable manual submit
        vf.verify
      end
    end
  end
end
