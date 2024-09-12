require "rails/generators"

class Storybook::ExamplesGenerator < Rails::Generators::Base
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
        include Storybook::Preview
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

  def create_example_partial
    create_file "app/views/application/_example.html.slim", <<~SLIM
      span
        = @title
    SLIM
  end

  def create_example_partial_preview
    # TODO: It goes here so the ViewComponent stuff can find it, but really should go elsewhere
    create_file "test/components/previews/example_partial_preview.rb", <<~RUBY
      # frozen_string_literal: true
      class ExamplePartialPreview < ViewComponent::Preview
        include Storybook::Preview
        def default
          render(Storybook::PartialPreviewComponent.new(partial: "application/example"))
        end
      end
    RUBY
  end
end
