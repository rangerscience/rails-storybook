namespace :storybook do
  desc "Write CSF JSON stories for all Stories"
  task stories: :environment do
    previews_dir = Rails.root.join("test/components/previews")
    Dir.glob("#{previews_dir}/**/*_preview.rb").each { |file| require file }

    stories = ViewComponent::Preview.descendants.map do |preview|
      [ preview.preview_name&.underscore, preview.to_csf ] if preview < Storybook::Preview
    end

    stories_dir = "stories"
    stories.each do |path, story|
      File.open(Rails.root.join("#{stories_dir}/#{path}.stories.json"), "w") do |f|
        f.write(JSON.pretty_generate(story))
      end
    end
  end
end
