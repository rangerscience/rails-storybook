require 'view_component'

module Storybook
  class PartialPreviewComponent < ViewComponent::Base
    slim_template <<~SLIM
      = render partial: @partial
    SLIM

    def initialize(partial:)
      @partial = partial
    end
  end
end
