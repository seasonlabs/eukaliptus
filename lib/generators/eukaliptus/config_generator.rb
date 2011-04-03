module Eukaliptus
  module Generators
    class ConfigGenerator < Rails::Generators::Base

      source_root File.expand_path("../../templates", __FILE__)

      desc <<-MSG
Description:
  Creates configuration files and stores them in `config`.

      MSG

      def generate_config
        template "facebook.yml", "config/facebook.yml"
      end
    end
  end
end