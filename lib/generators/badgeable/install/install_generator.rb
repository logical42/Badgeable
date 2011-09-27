require 'generators/badgeable'
require 'rails/generators'
require 'rails/generators/migration'

module Badgeable
  module Generators
    class VoteGenerator < Base
      include Rails::Generators::Migration
      argument :user_model, :type => :string, :default => 'user', :banner => 'user_name'
      def create_badge_models
        create_file "lib/badges.rb"
        generate("migration", "Badge name:string description:text icon:string")
        generate("migration", "Badging badgeable_id:integer badgeable_type:string badge_id:integer")
        
      end

    end
  end
end