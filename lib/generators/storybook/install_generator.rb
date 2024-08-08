require "rails/generators"

class Storybook::InstallGenerator < Rails::Generators::Base
  def install_storybook
    system "npx storybook@latest init --yes --dev --no-dev --builder webpack5"
    system "yarn add @storybook/server --dev"
    system "yarn add @storybook/server-webpack5 --dev"
    system "yarn install"
    insert_into_file "Procfile.dev", "storybook: yarn storybook -p 6006"
  end

  def install_rack_cors
    insert_into_file "Gemfile", "  gem 'rack-cors'\n", after: "group :development do\n"
    system "bundle install"
    create_file "config/initializers/cors.rb", <<~RUBY
      Rails.application.config.middleware.insert_before 0, Rack::Cors do
        allow do
          origins '*'
          resource '*', headers: :any, methods: [:get, :post, :patch, :put]
        end
      end
    RUBY
  end

  def create_storybook_layout_slim
    create_file "app/views/layouts/storybook.html.slim", <<~SLIM
      doctype html
      html lang='en'
        head
          title Trainyard
          meta charset="UTF-8"
          meta[name="viewport" content="width=device-width,initial-scale=1"]
          = csrf_meta_tags
          = csp_meta_tag
          = stylesheet_link_tag "tailwind", "inter-font", "data-turbo-track": "reload"
          = stylesheet_link_tag "application"
          = javascript_pack_tag "application"
        body
          div
            main.ml-64.p-8
              == yield
    SLIM
  end

  def update_storybook
    # Main.js
    insert_into_file ".storybook/main.js", "\n    \"@storybook/server\",", after: "addons: ["
    gsub_file ".storybook/main.js", "*.stories.@(js|jsx|mjs|ts|tsx)", "*.stories.@(js|jsx|mjs|ts|tsx|json)"
    gsub_file ".storybook/main.js", "@storybook/react-webpack5", "@storybook/server-webpack5"

    # Preview.js
    base_url = "http://localhost:3000/rails/view_components"
    insert_into_file ".storybook/preview.js", "\n    server: { url: \"#{base_url}\", },", after: "parameters: {"

    # insert_into_file ".storybook/main.js", "@storybook/addon-controls", after: "addons: ["
  end
end
