module Storybook
  module Preview
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def to_csf
        { title: component_name, stories: stories }
      end

      def stories
        instance_methods(false).collect { |name| story(name) }
      end

      def story(name)
        { name:, parameters: { server: { id: "#{component_name&.underscore}/#{name}" } } }
      end

      def component_name
        $1 if name  =~ /(.+Component)(?=Preview)/
      end
    end
  end
end
