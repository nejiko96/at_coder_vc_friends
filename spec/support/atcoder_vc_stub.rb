# frozen_string_literal: true

require 'cgi'

StubRequest = Struct.new(:method, :path, :param, :result) do
  def initialize(method, path, result: nil, **param)
    super(method, path, param, result)
  end

  def url
    ret = File.join("https://#{host}/", path)
    ret += "?#{query}" if query
    ret = Regexp.new(Regexp.escape(ret).gsub('@', '.*')) if ret.include?('@')
    ret
  end

  def query
    return nil unless method == :get && param && !param.empty?

    param.map { |k, v| "#{k}=#{v}" }.join('&')
  end

  def body
    method == :post ? param : ''
  end

  def register(result = nil)
    sr = WebMock.stub_request(method, url)
    sr = sr.with(body: body) if method == :post
    sr.to_return requested_page(result)
  end

  def requested_page(result)
    {
      status: 200,
      headers: { content_type: content_type },
      body: mock(result)
    }
  end

  def content_type
    path.end_with?('/json') ? 'application/json' : 'text/html'
  end

  def mock(result)
    pat = result || self.result
    mock_path = path
    mock_path += "_#{pat}" if pat && !pat.empty?
    mock_path += '_done' if method == :post
    mock_page(mock_path)
  end

  def mock_page(path)
    File.new(File.expand_path("../mocks/#{host}/#{path}.html", __dir__))
  end
end

class AcStubRequest < StubRequest
  def host
    'atcoder.jp'
  end
end

class VcStubRequest < StubRequest
  def host
    'not-522.appspot.com'
  end
end

REQS = [
  VcStubRequest.new(:get, 'contest/5141068792201216'),
  AcStubRequest.new(:get, 'contests/practice/submit'),
  AcStubRequest.new(
    :post, 'contests/practice/submit',
    'data.TaskScreenName': 'practice_1',
    'data.LanguageId': '3024',
    csrf_token: 'ZD8/jxTUFqgfOUYq0Y+/m7AygPqElU6UEV7nvp1mgEg=',
    sourceCode:
      <<~SRC
        a = gets.to_i
        b, c = gets.split.map(&:to_i)
        s = gets.chomp

        puts "\#{a + b + c} \#{s}"
      SRC
  ),
  AcStubRequest.new(:get, 'contests/abc067/tasks'),
  AcStubRequest.new(:get, 'contests/abc067/tasks/abc067_b'),
  AcStubRequest.new(:get, 'contests/abc094/tasks'),
  AcStubRequest.new(:get, 'contests/abc094/tasks/abc094_a'),
  AcStubRequest.new(:get, 'contests/agc009/tasks'),
  AcStubRequest.new(:get, 'contests/agc009/tasks/agc009_a'),
  AcStubRequest.new(:get, 'contests/arc080/tasks'),
  AcStubRequest.new(:get, 'contests/arc080/tasks/arc080_b'),
  AcStubRequest.new(:get, 'contests/cf16-final/tasks'),
  AcStubRequest.new(:get, 'contests/cf16-final/tasks/codefestival_2016_final_d'),
  AcStubRequest.new(:get, 'contests/code-festival-2016-qualc/tasks'),
  AcStubRequest.new(:get, 'contests/code-festival-2016-qualc/tasks/codefestival_2016_qualC_d')
].freeze


shared_context :atcoder_vc_stub do
  before :each do
    REQS.each(&:register)
  end
end
