require "minitest/autorun"
require "minitest/pride"

require "fastbillr"

module Fastbillr
  class Request
    private
      def self.connection
        Excon.new(Configuration.base_url, :headers => header, mock: true)
      end
  end
end

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/../test/fixtures/' + filename)
  File.read(file_path)
end
