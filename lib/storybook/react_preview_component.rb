require "view_component"
require "react_on_rails"

module Storybook
  class ReactPreviewComponent < ViewComponent::Base
    include ReactOnRails::Helper

    slim_template <<~SLIM
      = react_component @component, props: @props
    SLIM

    def initialize(component, **props)
      @component = component
      @props = props
    end
  end
end
