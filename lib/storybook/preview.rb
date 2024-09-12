module Storybook
  module Preview
    def self.included(base)
      base.extend ClassMethods
      base.layout "storybook"
    end

    module ClassMethods
      def to_csf
        { title: preview_name, stories: stories }
      end

      def stories
        instance_methods(false).collect { |name| story(name) }
      end

      def story(name)
        { name:, parameters: { server: { id: "#{preview_name.gsub("::", "/")}/#{name}" } } }
      end

      def preview_name
        component_name || partial_name || react_name
      end

      def component_name
        $1 if name  =~ /(.+Component)(?=Preview)/
      end

      def partial_name
        $1 if name  =~ /(.+Partial)(?=Preview)/
      end

      def react_name
        $1 if name  =~ /(.+React)(?=Preview)/
      end
    end
  end
end
