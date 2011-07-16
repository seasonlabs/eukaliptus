require 'rails'
require 'koala'
require 'eukaliptus/request'
require 'eukaliptus/middleware'

module Facebook
end

module Eukaliptus
  class Railtie < Rails::Railtie
    # Load rake tasks
    rake_tasks do
      load File.join(File.dirname(__FILE__), '../tasks/facebook.rake')
    end
    
    initializer "eukaliptus.middleware", :after => :after_initialize do |app|
      #ActionView::Base.send :include, Helper
      app.middleware.use Eukaliptus::Middleware
    end

    initializer "eukaliptus.koala" do |app|
      config_file = Rails.root.join("config/facebook.yml")

      if config_file.file?
        CONFIG = YAML.load_file(config_file)[Rails.env]
        Facebook::APP_ID = CONFIG['app_id']
        Facebook::SECRET = CONFIG['secret_key']
        Facebook::HOST = CONFIG['host']
        Facebook::CANVAS = CONFIG['canvas']
      end

      require 'eukaliptus/koala'
    end

    initializer "eukaliptus.action_view" do |app|
      ActiveSupport.on_load :action_view do
        require 'eukaliptus/view_helpers/facebook_helpers'
        include Eukaliptus::FacebookHelpers
      end
    end
  end
end