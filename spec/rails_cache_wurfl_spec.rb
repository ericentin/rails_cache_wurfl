require File.dirname(__FILE__) + '/spec_helper'

describe RailsCacheWurfl do
  describe 'rails_cache_wurfl base' do
    before(:all) do 
      Rails.cache.clear
    end

    it 'should load the wurfl into the cache if it is not present' do
       RailsCacheWurfl.init
       assert Rails.cache.read('wurfl_initialized')
     end

    it 'should return that the cache is initialized' do
      assert cache_initialized?
    end

    it 'should have cached the generic handset' do
      Rails.cache.read('generic').should_not be_nil
    end

    it 'should return nil given an invalid handset' do
      RailsCacheWurfl.get_handset('A Fake Handset').should be_nil
    end

    it 'should return a valid handset given a UA that can be truncated to a valid UA' do
      RailsCacheWurfl.get_handset('Nokia 30 foobaloo').should_not be_nil
    end
  end
end