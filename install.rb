require 'rails_cache_wurfl'

# Create necessary directory for wurfl.xml/pstore if it doesn't already exist.
FileUtils.mkdir_p(Rails.root + 'tmp/wurfl')

FileUtils.cd(Rails.root)
`rake wurfl:update`