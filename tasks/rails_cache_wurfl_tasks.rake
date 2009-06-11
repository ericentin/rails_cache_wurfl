namespace :wurfl do
  desc "Download the latest wurfl.xml.gz and unpack it."
  task :update do
    require Pathname.new(File.dirname(__FILE__)).join('..', 'lib', 'rails_cache_wurfl', 'wurfl', 'wurfl_load')
    
    FileUtils.mkdir_p(Rails.root.join('tmp', 'wurfl'))
    FileUtils.cd(Rails.root.join('tmp', 'wurfl'))
    
    return_code = `wget -N -- http://voxel.dl.sourceforge.net/sourceforge/wurfl/wurfl-latest.xml.gz`.to_i
    raise 'Failed to download wurfl-latest.xml.gz' unless return_code == 0
    
    return_code = `gunzip -c wurfl-latest.xml.gz > wurfl.xml`.to_i
    raise 'Failed to unzip wurfl-latest.xml.gz' unless return_code == 0
  end
  
  desc "Load the latest XML file into the cache."
  task :cache_update do
    require Pathname.new(File.dirname(__FILE__)).join('..', 'lib', 'rails_cache_wurfl', 'cache_initializer')
    require Rails.root.join('config', 'environment.rb')
    puts 'This can take a minute or two. Thank you for your patience.'
    refresh_cache
  end
end