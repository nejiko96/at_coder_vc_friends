# frozen_string_literal: true

RSpec.describe AtCoderVcFriends::PathInfo do

  subject(:path_info) { described_class.new(path) }

  describe '#contest_name' do
    subject { path_info.contest_name }

    context 'from file' do
      let(:path) { '/foo/bar/contest/abc_123#A.rb' }

      it 'returns contest name' do
        expect(subject).to eq('abc_123')
      end
    end
  end

  describe '#components' do
    subject { path_info.components }
    let(:path) { '/foo/bar/contest/abc_123#A_v2.rb' }

    it 'splits given path' do
      expect(subject).to match(
        [
          '/foo/bar/contest/abc_123#A_v2.rb',
          '/foo/bar/contest',
          'abc_123#A_v2.rb',
          'abc_123#A_v2',
          'rb',
          'abc_123#A'
        ]
      )
    end
  end
end
