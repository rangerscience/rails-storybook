require "rails/generators"

class Storybook::ExampleGenerator < Rails::Generators::Base
  def install_view_components
    insert_into_file "Gemfile", "gem 'view_component'"
    system "bundle install"
  end

  def create_example_component
    create_file "app/components/example_component.rb", <<~RUBY
      # frozen_string_literal: true

      class ExampleComponent < ViewComponent::Base
        slim_template <<~SLIM
          span
            = @title
        SLIM

        def initialize(title:)
          @title = title
        end
      end
    RUBY
  end

  def create_example_component_preview
    create_file "test/components/previews/example_component_preview.rb", <<~RUBY
      # frozen_string_literal: true

      class ExampleComponentPreview < ViewComponent::Preview
        layout "storybook"
        def default
          render(ExampleComponent.new(title: "title"))
        end

        def with_content_block
          render(ExampleComponent.new(title: "This component accepts a block of content")) do
            tag.div do
              content_tag(:span, "Hello")
            end
          end
        end
      end
    RUBY
  end

  def create_example_story
    create_file "stories/example_component.stories.json", <<~JSON
      {
        "title": "ExampleComponent",
        "stories": [
          {
            "name": "default",
            "parameters": {
              "server": { "id": "example_component/default" }
            }
          }
        ]
      }
    JSON
  end
end
