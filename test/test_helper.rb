require "minitest/autorun"
require "minitest/pride"

require "fastbillr"

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/../test/fixtures/' + filename)
  File.read(file_path)
end
