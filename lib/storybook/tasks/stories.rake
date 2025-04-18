namespace :storybook do
  desc "Write CSF JSON stories for all Stories"
  task stories: :environment do
    stories_dir = "stories"
    # TODO: Also needs to *remove* stale stories
    RailsPreviews::Preview.all.map do |preview|
      filename = Rails.root.join("#{stories_dir}/#{preview.preview_name}.stories.json")
      stories_json = JSON.pretty_generate(preview.to_csf)
      file = Pathname(filename)
      file.dirname.mkpath unless file.dirname.exist?
      file.write(stories_json)
    end
  end
end
