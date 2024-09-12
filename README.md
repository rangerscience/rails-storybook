# Rails::Storybook

[![Gem Version](https://badge.fury.io/rb/rails-storybook.svg)](https://badge.fury.io/rb/rails-storybook)
![ci](https://github.com/rangerscience/rails-storybook/actions/workflows/ci.yml/badge.svg)
[![code-climate](https://codeclimate.com/github/rangerscience/rails-storybook.svg)](https://codeclimate.com/github/rangerscience/rails-storybook)

Storybook is a very cool Javascript ecosystem tool, aiding in the development of component-based UIs. It takes a little bit of doing to make it play nicely with Rails. And, a main benefit of using Storybook is that it lets you use Chromatic - which means no more need for *a lot* of your UI tests!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails-storybook'
```

Then:
```bash
rails g storybook:install
```

Then, optionally:
```bash
rails g storybook:examples
```

Restart your processes (stop and restart `./bin/dev`) and viola! Opens up a Storybook connected to your Rails server, and if you've also generated the example, will have a simple View Component showing up in Storybook.

## Usage

Write a preview for your component, just like normal - but include the StoryBook::Preview module. You can also use the `PartialPreviewComponent` to render regular Rails partials as previews.
```ruby
class ExampleComponentPreview < ViewComponent::Preview
  include Storybook::Preview
  def default
    render(ExampleComponent.new(title: "title"))
  end
  
  def default
    render(PartialPreviewComponent.new(partial: "application/example"))
  end
end
```
Note that the module will set the preview's layout to `storybook`, as there's steps to be done to make it look good (and work!) inside of Storybook.

Then run `rake storybook:stories` to generate the CSF JSON that Storybook uses to find your previews.

And... that's it! :D  


## Development

Inspired by [gem view_component-storybook](https://github.com/jonspalmer/view_component-storybook), but, I want to accomplish things in a different way, to aim higher (handling ~~view components~~, ~~partials~~, *and* React components), and to aim specifically at integration with Chromatic.

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rangerscience/rails-storybook. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rails::Storybook project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rangerscience/rails-storybook/blob/master/CODE_OF_CONDUCT.md).
