require 'eukaliptus/middleware'
require 'rails'
  
module Eukaliptus
  class Railtie < Rails::Railtie
    initializer "eukaliptus.initializer", :after => :after_initialize do |app|
      #ActionView::Base.send :include, Helper
      app.middleware.use Eukaliptus::Middleware
    end
  end
end