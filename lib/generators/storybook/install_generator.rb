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

  def update_storybook
    # Main.js
    insert_into_file ".storybook/main.js", "\n    \"@storybook/server\",", after: "addons: ["
    gsub_file ".storybook/main.js", "*.stories.@(js|jsx|mjs|ts|tsx)", "*.stories.@(json)"
    gsub_file ".storybook/main.js", "@storybook/react-webpack5", "@storybook/server-webpack5"

    # Preview.js
    base_url = "http://localhost:3000/rails/view_components"

    # Preferred method to get the styling loaded in:
    #insert_into_file ".storybook/preview.js", "\nimport '../public/assets/tailwind-0c2ceb08e52f57602c2ff891790dee8451074b84335e77f107abdb57f99a2c37.css'", before: "export default preview;"
    #insert_into_file ".storybook/preview.js", "\nimport '../public/assets/application-9f334b542cffee1084a19870f2b1f16b1ef66ff68bfa765286993d260bc9556a.css'", before: "export default preview;"

    insert_into_file ".storybook/preview.js", "\n    server: { url: \"#{base_url}\", },", after: "parameters: {"

    # insert_into_file ".storybook/main.js", "@storybook/addon-controls", after: "addons: ["

    # Stylesheets so Storybook can find them
    # TODO: TailwindCSS / JS packs name, etc
    # TODO: Server & port
    create_file ".storybook/.preview-head.html", <<~HTML
      <link rel="stylesheet" href="http://localhost:3000/assets/tailwind.css" data-turbo-track="reload">
      <link rel="stylesheet" href="http://localhost:3000/assets/inter-font.css" data-turbo-track="reload">
      <link rel="stylesheet" href="http://localhost:3000/assets/application.css" data-turbo-track="reload">
      <script src="http://localhost:3000/packs/js/application.js" defer="defer"></script>
    HTML
  end

  def create_storybook_layout
    # TODO: TailwindCSS / etc
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
end
