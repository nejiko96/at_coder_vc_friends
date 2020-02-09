# frozen_string_literal: true

shared_context :atcoder_vc_env do
  include FileHelper

  before :all do
    spec_root = File.expand_path('..', __dir__)
    @project_root = File.join(spec_root, 'fixtures', 'AtCoderVC')
    @contest_root = File.join(project_root, 'some_contest')
    @smp_dir = File.join(contest_root, 'data')
    @tmp_dir = File.join(contest_root, '.tmp')
  end

  before :each do
    rmdir_force(tmp_dir)
  end

  after :all do
    rmdir_force(tmp_dir)
    FileUtils.rm(Dir.glob(smp_dir + '/*.out'))
  end

  attr_reader :project_root, :contest_root, :smp_dir, :tmp_dir
end
