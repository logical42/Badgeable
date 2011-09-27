require 'generators/badgeable'
require 'rails/generators'
require 'rails/generators/migration'

module Badge
  module Generators
    class InstallGenerator < Base
      include Rails::Generators::Migration
      argument :user_model, :type => :string, :default => 'user', :banner => 'user_name'
      def create_lib_badges_file
        copy_file "badgeable.rb", "config/initializers/badgeable.rb"
        create_file "lib/badges.rb"
      end
      def add_gem
        insert_into_file "Gemfile", "gem 'badgeable', git: 'git://github.com/logical42/Badgeable.git'\n", :after => "gem \'jquery-rails\'\n"
      end

      
    end
  end
end