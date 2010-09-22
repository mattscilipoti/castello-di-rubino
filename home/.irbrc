require 'rubygems'
require 'wirble'

Wirble.init
Wirble.colorize



puts "`include RailsHelper` for named_urls, helpers, etc."

module RailsHelper
  def self.included(base)
    Gem.send('require', 'database_cleaner')
    Gem.send('require', 'hirb')
    
    Hirb::View.enable
    
    #TODO: is there better way than #send?
    begin
      Gem.send('require', 'arspy')
    rescue LoadError
      puts 'gem "arspy" is not installed'
    end
    
    ##from: http://kpumuk.info/ruby-on-rails/memo-6-using-named-routes-and-url_for-outside-the-controller-in-ruby-on-rails/
    ## this is slow because all routes and resources being calculated now
    if Rails.version.to_i < 3
      base.send('include', ActionController::UrlWriter)
    else
      base.send('include', Rails.application.routes.url_helpers)
    end
    base.default_url_options[:host] = 'www.example.com'
    puts "You can now utilize named_urls"
  
    # DatabaseCleaner.strategy = :truncation, {:except => SeedData.seed_tables }
    # puts "You can now utilize DatabaseCleaner.clean"

    # print SQL to STDOUT
    if !Object.const_defined?('RAILS_DEFAULT_LOGGER')
      require 'logger'
      const_set('RAILS_DEFAULT_LOGGER', Logger.new(STDOUT))
      ActiveRecord::Base.logger = Logger.new(STDOUT)
    end

  end
end

if ENV['RAILS_ENV']
#  include RailsHelper
end

# Autocomplete
require 'irb/completion'

# Prompt behavior
ARGV.concat [ "--readline", "--prompt-mode", "simple" ]

# History
require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"

# Easily print methods local to an object's class
class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end
end

## copy a string to the clipboard (Mac only)
#def pbcopy(string)
#  `echo "#{string}" | pbcopy`
#  string
#end
