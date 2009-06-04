require 'test_helper'

class MemcacheWurflTest < ActiveSupport::TestCase
  test "load wurfl XML into pstore" do
    require 'memcache_wurfl/wurfl_load'
    loader = WurflLoader.new
    puts `pwd`
    loader.load_wurfl_old('../../../tmp/wurfl/wurfl.xml')
    assert true
  end
end