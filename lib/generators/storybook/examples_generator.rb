require "rails/generators"

class Storybook::ExamplesGenerator < Rails::Generators::Base
  def create_example_partial
    create_file "app/views/application/_example.html.slim", <<~SLIM
      h3 Example Partial
      span= @title
    SLIM
  end

  def create_example_partial_preview
    create_file "spec/previews/example_partial.rb", <<~RUBY
      # frozen_string_literal: true
      module Previews
        class ExamplePartial < RailsPreviews::Preview
          def default
            render_partial "application/example", locals: { title: "Hello, World!" }
          end
        end
      end
    RUBY
  end

  def install_view_components
    insert_into_file "Gemfile", "gem \"view_component\""
    system "bundle install"
  end

  def create_example_view_component
    create_file "app/components/example_component.rb", <<~RUBY
      # frozen_string_literal: true

      class ExampleComponent < ViewComponent::Base
        slim_template <<~SLIM
          h3 Example Component
          span= @title
        SLIM

        def initialize(title:)
          @title = title
        end
      end
    RUBY
  end

  def create_example_view_component_preview
    create_file "spec/previews/example_view_component.rb", <<~RUBY
      # frozen_string_literal: true

      module Previews
        class ExampleViewComponent < RailsPreviews::Preview
          def default
            ExampleComponent.new(title: "Hello, World!")
          end

          # TODO - This doesn't work with the current Previews implementation
          # def with_content_block
          #   render(ExampleComponent.new(title: "This component accepts a block of content")) do
          #     tag.div do
          #       content_tag(:span, "Hello")
          #     end
          #   end
          # end
        end
      end
    RUBY
  end

  def install_react_on_rails
    insert_into_file "Gemfile", "\ngem \"react_on_rails\""
    system "bundle install"
  end

  def setup_application_bundle
    # TODO: I have my pack in not the default location
  end

  def create_example_react_component
    create_file "client/bundles/application/components/HelloWorld.jsx", <<~JSX
      import PropTypes from 'prop-types';
      import React, { useState } from 'react';
      import * as style from './HelloWorld.module.css';

      const HelloWorld = (props) => {
        return (
          <div>
            <h3>Example React Component</h3>
            <span>{props.name}</span>
          </div>
        );
      };

      HelloWorld.propTypes = {
        name: PropTypes.string.isRequired, // this is passed from the Rails view
      };

      export default HelloWorld;
    JSX

    create_file "client/bundles/application/components/HelloWorld.module.css", <<~CSS
      .bright {
        color: green;
        font-weight: bold;
      }#{'  '}
    CSS

    # TODO: Is this necessary?
    create_file "client/bundles/application/components/HelloWorldServer.js", <<~JS
      import HelloWorld from './HelloWorldServer';
      export default HelloWorld;
    JS

    create_file "client/packs/application.js", <<~JS
      import ReactOnRails from 'react-on-rails';
      import HelloWorld from '../bundles/application/components/HelloWorld';
      ReactOnRails.register({ HelloWorld });
    JS

    # TODO: Is this necessary?
    create_file "client/packs/server-bundle.js", <<~JS
      import ReactOnRails from 'react-on-rails';
      import HelloWorld from '../bundles/application/components/HelloWorld';
      ReactOnRails.register({ HelloWorld });
    JS
  end

  def create_example_react_component_preview
    create_file "spec/previews/example_react_component.rb", <<~RUBY
      # frozen_string_literal: true

      module Previews
        class ExampleReactComponent < RailsPreviews::Preview
          def default
            render_react_on_rails "HelloWorld", props: { name: "Hello, World!" }
          end
        end
      end
    RUBY
  end

  def generate_stories
    `rails storybook:stories`
  end
end
