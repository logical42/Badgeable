require 'rails/generators'

module Badgeable
  class Railtie < ::Rails::Railtie
    include Rails::Generators
    # AK - set the directory where badges description will appear
    generators do
      require "generators/badgeable/install"
      create_file "lib/badges.rb"
    end
    initializer "badgeable.assign_badge_definitions_file" do
      
      Badgeable::Config.badge_definitions = Pathname.new("#{Rails.root}/lib/badges.rb")
    end
    config.to_prepare do
      Badgeable::Dsl.class_eval(File.read(Badgeable::Config.badge_definitions))
    end
  end
end
