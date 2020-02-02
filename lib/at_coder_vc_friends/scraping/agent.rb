# frozen_string_literal: true

require 'at_coder_friends'

module AtCoderVcFriends
  module Scraping
    # scraping agent for virtual contest
    class Agent < AtCoderFriends::Scraping::Agent
      def fetch_all_vc(contest_url)
        puts '***** fetch_all_vc *****'
        fetch_assignments_vc(contest_url).map do |pbm_url|
          pbm = fetch_problem_vc(pbm_url)
          yield pbm if block_given?
          pbm
        end
      end

      def fetch_assignments_vc(contest_url)
        puts "fetch list from #{contest_url} ..."
        page = agent.get(contest_url)
        page
          .search('//table[1]//thead//a')
          .map { |a| a[:href] }
      end

      def fetch_problem_vc(pbm_url)
        m = pbm_url.match('/contests/(?<contest>.+)/tasks/(?<task>.+)')
        contest = m[:contest]
        key = task_key(pbm_url)
        q = "#{contest}##{key}"
        fetch_problem(q, pbm_url)
      end

      def task_key(pbm_url)
        tasks_url = File.dirname(pbm_url)
        page = fetch_with_auth(tasks_url)
        page
          .search('//table[1]//td[1]//a')
          .find { |a| pbm_url.end_with?(a[:href]) }
          .text
      end

      def post_submit(q, lang, src)
        super.post_submit(q.split('#')[1], lang, src)
      end
    end
  end
end
