namespace :wurfl do
  desc "Download the latest wurfl.xml.gz and unpack it."
  # task :update do
  task :update, :latest_wurfl_filename do |t, args|
    require Pathname.new(File.dirname(__FILE__)).join('..', 'lib', 'rails_cache_wurfl', 'wurfl', 'wurfl_load')
    latest_wurfl_filename = args.latest_wurfl_filename
    
    FileUtils.mkdir_p(Rails.root.join('tmp', 'wurfl'))
    FileUtils.cd(Rails.root.join('tmp', 'wurfl'))
    
    result = system("wget -N -- http://sourceforge.net/projects/wurfl/files/WURFL/2.2/#{latest_wurfl_filename}")
    raise "Failed to download #{latest_wurfl_filename}" unless result
    raise "Failed to download #{latest_wurfl_filename}" unless system("ls -lia #{latest_wurfl_filename}")
    
    result = system("gunzip -c #{latest_wurfl_filename} > wurfl.xml")
    raise "Failed to unzip #{latest_wurfl_filename}" unless result
  end
  
  desc "Load the latest XML file into the cache."
  task :cache_update do
    require Pathname.new(File.dirname(__FILE__)).join('..', 'lib', 'rails_cache_wurfl', 'cache_initializer')
    require Rails.root.join('config', 'environment.rb')
    puts 'This can take a minute or two. Be patient.'
    RailsCacheWurfl::CacheInitializer.refresh_cache
  end
end