# frozen_string_literal: true

RSpec.describe AtCoderVcFriends::CLI do
  include FileHelper
  include_context :atcoder_vc_env

  subject(:cli) { described_class.new }
  let(:args) { [command, path] }
  let(:path) { File.join(contest_root, src) }
  let(:src) { 'practice#A.rb' }
  let(:ctx) { AtCoderFriends::Context.new({}, path) }

  USAGE = <<~TEXT
    Usage:
      at_coder_vc_friends setup        path/to/contest url # setup contest folder
      at_coder_vc_friends test-one     path/to/src         # run 1st test case
      at_coder_vc_friends test-all     path/to/src         # run all test cases
      at_coder_vc_friends submit       path/to/src         # submit source code
      at_coder_vc_friends check-and-go path/to/src         # submit source if all tests passed
    Options:
        -v, --version                    Display version.
        -d, --debug                      Display debug info.
  TEXT

  subject { cli.run(args) }
  describe 'exiting options' do
    context '-v' do
      let(:args) { ['-v'] }
      it 'shows version' do
        expect { subject }.to output("#{AtCoderFriends::VERSION}\n").to_stdout
        expect(subject).to eq(0)
      end
    end

    context '--version' do
      let(:args) { ['--version'] }
      it 'shows version' do
        expect { subject }.to output("#{AtCoderFriends::VERSION}\n").to_stdout
        expect(subject).to eq(0)
      end
    end

    context '-h' do
      let(:args) { ['-h'] }
      it 'shows usage' do
        expect { subject }.to output(USAGE).to_stdout
        expect(subject).to eq(0)
      end
    end

    context '--help' do
      let(:args) { ['--help'] }
      it 'shows usage' do
        expect { subject }.to output(USAGE).to_stdout
        expect(subject).to eq(0)
      end
    end
  end

  describe 'argument errors' do
    context 'when the option does not exist' do
      let(:args) { ['--nothing'] }
      it 'shows usage' do
        expect { subject }.to \
          output(USAGE + "error: invalid option: --nothing\n").to_stderr
        expect(subject).to eq(1)
      end
    end

    context 'when the number of arguments is wrong' do
      let(:args) { ['setup'] }
      it 'shows usage' do
        expect { subject }.to \
          output(USAGE + "error: command or path is not specified.\n")
          .to_stderr
        expect(subject).to eq(1)
      end
    end

    context 'with a unknown command' do
      let(:command) { 'init' }
      it 'shows usage' do
        expect { subject }.to \
          output(USAGE + "error: unknown command: init\n").to_stderr
        expect(subject).to eq(1)
      end
    end
  end

  describe 'setup' do
    let(:command) { 'setup' }
    let(:args) { [command, path, url] }
    let(:url) { 'https://not-522.appspot.com/contest/5141068792201216' }

    context 'when the folder is not empty' do
      let(:path) { contest_root }
      it 'shows error' do
        expect { subject }.to \
          output("#{contest_root} is not empty.\n").to_stderr
        expect(subject).to eq(1)
      end
    end

    context 'with no errors' do
      include_context :uses_temp_dir
      include_context :atcoder_vc_stub
      include_context :evacuate_session

      let(:path) { File.join(temp_dir, 'KBC001') }
      let(:f) { ->(file) { File.join(path, file) } }
      let(:e) { ->(file) { File.exist?(f[file]) } }

      shared_examples 'normal case' do
        it 'generates examples and sources' do
          expect { subject }.to output(
            <<~OUTPUT
              ***** fetch_all_vc *****
              fetch list from https://not-522.appspot.com/contest/5141068792201216 ...
              logged in as foo (Guest)
              fetch problem from https://atcoder.jp/contests/abc094/tasks/abc094_a ...
              abc094#A_001.in
              abc094#A_001.exp
              abc094#A_002.in
              abc094#A_002.exp
              abc094#A_003.in
              abc094#A_003.exp
              abc094#A.rb
              abc094#A.cxx
              fetch problem from https://atcoder.jp/contests/abc067/tasks/abc067_b ...
              abc067#B_001.in
              abc067#B_001.exp
              abc067#B_002.in
              abc067#B_002.exp
              abc067#B.rb
              abc067#B.cxx
              fetch problem from https://atcoder.jp/contests/agc009/tasks/agc009_a ...
              agc009#A_001.in
              agc009#A_001.exp
              agc009#A_002.in
              agc009#A_002.exp
              agc009#A.rb
              agc009#A.cxx
              fetch problem from https://atcoder.jp/contests/arc080/tasks/arc080_b ...
              arc080#D_001.in
              arc080#D_001.exp
              arc080#D_002.in
              arc080#D_002.exp
              arc080#D_003.in
              arc080#D_003.exp
              arc080#D.rb
              arc080#D.cxx
              fetch problem from https://atcoder.jp/contests/cf16-final/tasks/codefestival_2016_final_d ...
              cf16-final#D_001.in
              cf16-final#D_001.exp
              cf16-final#D_002.in
              cf16-final#D_002.exp
              cf16-final#D.rb
              cf16-final#D.cxx
              fetch problem from https://atcoder.jp/contests/code-festival-2016-qualc/tasks/codefestival_2016_qualC_d ...
              code-festival-2016-qualc#D_001.in
              code-festival-2016-qualc#D_001.exp
              code-festival-2016-qualc#D_002.in
              code-festival-2016-qualc#D_002.exp
              code-festival-2016-qualc#D_003.in
              code-festival-2016-qualc#D_003.exp
              code-festival-2016-qualc#D_004.in
              code-festival-2016-qualc#D_004.exp
              code-festival-2016-qualc#D_005.in
              code-festival-2016-qualc#D_005.exp
              code-festival-2016-qualc#D.rb
              code-festival-2016-qualc#D.cxx
            OUTPUT
          ).to_stdout
          expect(e['data/abc094#A_001.in']).to be true
          expect(e['data/abc094#A_001.exp']).to be true
          expect(e['data/abc094#A_002.in']).to be true
          expect(e['data/abc094#A_002.exp']).to be true
          expect(e['data/abc094#A_003.in']).to be true
          expect(e['data/abc094#A_003.exp']).to be true
          expect(e['abc094#A.rb']).to be true
          expect(e['abc094#A.cxx']).to be true
          expect(e['data/abc067#B_001.in']).to be true
          expect(e['data/abc067#B_001.exp']).to be true
          expect(e['data/abc067#B_002.in']).to be true
          expect(e['data/abc067#B_002.exp']).to be true
          expect(e['abc067#B.rb']).to be true
          expect(e['abc067#B.cxx']).to be true
          expect(e['data/agc009#A_001.in']).to be true
          expect(e['data/agc009#A_001.exp']).to be true
          expect(e['data/agc009#A_002.in']).to be true
          expect(e['data/agc009#A_002.exp']).to be true
          expect(e['agc009#A.rb']).to be true
          expect(e['agc009#A.cxx']).to be true
          expect(e['data/arc080#D_001.in']).to be true
          expect(e['data/arc080#D_001.exp']).to be true
          expect(e['data/arc080#D_002.in']).to be true
          expect(e['data/arc080#D_002.exp']).to be true
          expect(e['data/arc080#D_003.in']).to be true
          expect(e['data/arc080#D_003.exp']).to be true
          expect(e['arc080#D.rb']).to be true
          expect(e['arc080#D.cxx']).to be true
          expect(e['data/cf16-final#D_001.in']).to be true
          expect(e['data/cf16-final#D_001.exp']).to be true
          expect(e['data/cf16-final#D_002.in']).to be true
          expect(e['data/cf16-final#D_002.exp']).to be true
          expect(e['cf16-final#D.rb']).to be true
          expect(e['cf16-final#D.cxx']).to be true
          expect(e['data/code-festival-2016-qualc#D_001.in']).to be true
          expect(e['data/code-festival-2016-qualc#D_001.exp']).to be true
          expect(e['data/code-festival-2016-qualc#D_002.in']).to be true
          expect(e['data/code-festival-2016-qualc#D_002.exp']).to be true
          expect(e['data/code-festival-2016-qualc#D_003.in']).to be true
          expect(e['data/code-festival-2016-qualc#D_003.exp']).to be true
          expect(e['data/code-festival-2016-qualc#D_004.in']).to be true
          expect(e['data/code-festival-2016-qualc#D_004.exp']).to be true
          expect(e['data/code-festival-2016-qualc#D_005.in']).to be true
          expect(e['data/code-festival-2016-qualc#D_005.exp']).to be true
          expect(e['code-festival-2016-qualc#D.rb']).to be true
          expect(e['code-festival-2016-qualc#D.cxx']).to be true
        end
      end

      context 'when the folder does not exist' do
        it_behaves_like 'normal case'
      end

      context 'when the folder is empty' do
        before { Dir.mkdir(path) }
        it_behaves_like 'normal case'
      end
    end
  end

  describe 'test-one' do
    let(:command) { 'test-one' }

    context 'if the test no. is not specified' do
      it 'runs 1st test case' do
        expect { subject }.to output(
          <<~OUTPUT
            ***** test_one practice#A.rb (local) *****
            ==== practice#A_001 ====
            -- input --
            1
            2 3
            test
            -- expected --
            6 test
            -- result --
            6 test
            \e[0;32;49m<< OK >>\e[0m
          OUTPUT
        ).to_stdout
      end
    end

    context 'if the test no. is specified' do
      let(:args) { [command, path, id] }
      let(:id) { '002' }

      it 'runs specified test case' do
        expect { subject }.to output(
          <<~OUTPUT
            ***** test_one practice#A.rb (local) *****
            ==== practice#A_002 ====
            -- input --
            72
            128 256
            myonmyon
            -- expected --
            456 myonmyon
            -- result --
            456 myonmyon
            \e[0;32;49m<< OK >>\e[0m
          OUTPUT
        ).to_stdout
      end
    end
  end

  describe 'test-all' do
    let(:command) { 'test-all' }
    let(:vf_path) { File.join(tmp_dir, 'practice#A.rb.verified') }
    before { ctx.verifier.unverify }

    it 'runs all test cases' do
      expect { subject }.to output(
        <<~OUTPUT
          ***** test_all practice#A.rb (local) *****
          ==== practice#A_001 ====
          -- input --
          1
          2 3
          test
          -- expected --
          6 test
          -- result --
          6 test
          \e[0;32;49m<< OK >>\e[0m
          ==== practice#A_002 ====
          -- input --
          72
          128 256
          myonmyon
          -- expected --
          456 myonmyon
          -- result --
          456 myonmyon
          \e[0;32;49m<< OK >>\e[0m
        OUTPUT
      ).to_stdout
    end

    it 'mark the source as verified' do
      expect { subject }.to \
        change { File.exist?(vf_path) }.from(false).to(true)
    end
  end

  describe 'submit' do
    let(:command) { 'submit' }

    context 'when the source has not been tested' do
      it 'shows error' do
        expect { subject }.to \
          output("practice#A.rb has not been tested.\n").to_stderr
        expect(subject).to eq(1)
      end
    end

    context 'when there is no error' do
      include_context :atcoder_vc_stub
      include_context :evacuate_session

      let(:vf_path) { File.join(tmp_dir, 'practice#A.rb.verified') }
      before { ctx.verifier.verify }

      it 'posts the source' do
        expect { subject }.to output(
          <<~OUTPUT
            ***** submit practice#A.rb *****
            logged in as foo (Contestant)
          OUTPUT
        ).to_stdout
      end

      it 'mark the source as unverified' do
        expect { subject }.to \
          change { File.exist?(vf_path) }.from(true).to(false)
      end
    end
  end

  describe 'check-and-go' do
    let(:command) { 'check-and-go' }

    context 'when all tests passed' do
      include_context :atcoder_vc_stub
      include_context :evacuate_session

      let(:vf_path) { File.join(tmp_dir, 'practice#A.rb.verified') }
      before { ctx.verifier.verify }

      it 'runs all tests and posts the source' do
        expect { subject }.to output(
          <<~OUTPUT
            ***** test_all practice#A.rb (local) *****
            ==== practice#A_001 ====
            -- input --
            1
            2 3
            test
            -- expected --
            6 test
            -- result --
            6 test
            \e[0;32;49m<< OK >>\e[0m
            ==== practice#A_002 ====
            -- input --
            72
            128 256
            myonmyon
            -- expected --
            456 myonmyon
            -- result --
            456 myonmyon
            \e[0;32;49m<< OK >>\e[0m
            ***** submit practice#A.rb *****
            logged in as foo (Contestant)
          OUTPUT
        ).to_stdout
      end

      it 'mark the source as unverified' do
        expect { subject }.to \
          change { File.exist?(vf_path) }.from(true).to(false)
      end
    end

    context 'when some test fails' do
      let(:vf_path) { File.join(tmp_dir, 'practice#A.rb.verified') }
      before(:all) do
        File.rename(
          File.join(smp_dir, 'practice#A_002.exp'),
          File.join(smp_dir, 'practice#A_003.exp')
        )
      end

      after(:all) do
        File.rename(
          File.join(smp_dir, 'practice#A_003.exp'),
          File.join(smp_dir, 'practice#A_002.exp')
        )
      end

      before { ctx.verifier.unverify }

      it 'runs all tests and does not post the source' do
        expect { subject }.to output(
          <<~OUTPUT
            ***** test_all practice#A.rb (local) *****
            ==== practice#A_001 ====
            -- input --
            1
            2 3
            test
            -- expected --
            6 test
            -- result --
            6 test
            \e[0;32;49m<< OK >>\e[0m
            ==== practice#A_002 ====
            -- input --
            72
            128 256
            myonmyon
            -- expected --
            (no expected value)
            -- result --
            456 myonmyon

          OUTPUT
        ).to_stdout
      end

      it 'mark the source as verified' do
        expect { subject }.to \
          change { File.exist?(vf_path) }.from(false).to(true)
      end
    end
  end
end
