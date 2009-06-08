namespace :wurfl do
  desc "Download the latest wurfl.xml.gz and unpack it."
  task :update do
    puts FileUtils.pwd
    puts $LOAD_PATH
    require 'rails_cache_wurfl/wurfl_load'
    FileUtils.mkdir_p(Rails.root.join 'tmp/wurfl')
    return_code = `cd tmp/wurfl/ && wget -N -- http://voxel.dl.sourceforge.net/sourceforge/wurfl/wurfl-latest.xml.gz`.to_i
    unless return_code == 0
      raise 'Failed to download wurfl-latest.xml.gz'
    end

    return_code = `cd tmp/wurfl/ && gunzip -c wurfl-latest.xml.gz > wurfl.xml`.to_i
    unless return_code == 0
      raise 'Failed to unzip wurfl-latest.xml.gz'
    end

    return_code = `cd lib && ruby wurfl/wurflloader.rb -d wurfl/wurfl_pstore -f wurfl/wurfl.xml`
  end
end