
module Rails::Previews
  # Re-open the class to add the Storybook methods
  class Preview
    class << self
      def to_csf
        { title: preview_name, stories: stories }
      end

      def stories
        examples.collect do |name|
          { name:, parameters: { server: { id: "#{preview_name}/#{name}" } } }
        end
      end
    end
  end
end
