require "storybook"
require "rails"

# https://gist.github.com/ntamvl/7a6658b4cd82d6fbd15434f0a9953411
module Storybook
  class Railtie < Rails::Railtie
    railtie_name :storybook

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end
