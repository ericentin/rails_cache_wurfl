require File.dirname(__FILE__) + '/spec_helper'

describe RailsCacheWurfl do
 before(:all) do 
   Rails.cache.clear
   sleep(1) #bizarre flush_all memcached thing
   RailsCacheWurfl.init
 end
 
 it 'should load the wurfl into the cache if it is not present' do
   assert Rails.cache.read('wurfl_initialized')
 end
 
 it 'should return that the cache is initialized' do
   assert cache_initialized?
 end
 
 it 'should return a generic handset' do
   Rails.cache.read('generic').should_not be_nil
 end
   
end