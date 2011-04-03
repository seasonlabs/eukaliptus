require 'eukaliptus/middleware'
require 'rails'
  
module Eukaliptus
  class Railtie < Rails::Railtie
    # Load rake tasks
    rake_tasks do
      load File.join(File.dirname(__FILE__), 'tasks/facebook.rake')
    end
    
    initializer "eukaliptus.initializer", :after => :after_initialize do |app|
      #ActionView::Base.send :include, Helper
      app.middleware.use Eukaliptus::Middleware
    end
  end
end