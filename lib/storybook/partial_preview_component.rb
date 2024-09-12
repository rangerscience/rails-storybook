require "view_component"

module Storybook
  class PartialPreviewComponent < ViewComponent::Base
    slim_template <<~SLIM
      = render partial: @partial, locals: @locals
    SLIM

    def initialize(partial:, **locals)
      @partial = partial
      @locals = locals
    end
  end
end
