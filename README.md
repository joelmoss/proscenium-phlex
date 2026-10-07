# Proscenium::Phlex

[Proscenium](https://proscenium.rocks/) integration for Phlex.

## Requirements

- Ruby >= 3.4
- [Proscenium](https://github.com/joelmoss/proscenium) ~> 0.26
- Rails >= 7.1 and < 9.0
- Phlex Rails >= 1.2 and < 3.0

## Usage

[Phlex](https://www.phlex.fun/) is a framework for building fast, reusable, testable views in pure Ruby. [Proscenium](https://proscenium.rocks/) works perfectly with [Phlex](https://www.phlex.fun), with support for side-loading, CSS modules, and more.

### Include Assets

Include `Proscenium::Phlex::IncludeAssets`, and call the `include_assets` helper.

```ruby
class ApplicationLayout < Phlex::HTML
  include Proscenium::Phlex::IncludeAssets # <--

  def view_template(&)
    doctype
    html do
      head do
        title { 'My Awesome App' }
        include_assets # <--
      end
      body(&)
    end
  end
end
```

You can specifically include CCS and JS assets using the `include_stylesheets` and `include_javascripts` helpers, allowing you to control where they are included in the HTML.

### Side-loading

Include `Proscenium::Phlex::Sideload` in your components, and it will automatically be [side-loaded](https://github.com/joelmoss/proscenium?tab=readme-ov-file#side-loading).

```ruby
class MyComponent < Phlex::HTML
  include Proscenium::Phlex::Sideload # <--

  def view_template(&)
    # ...
  end
end
```

### CSS Modules

[CSS Modules](https://github.com/joelmoss/proscenium?tab=readme-ov-file#css-modules) are fully supported in Phlex classes, with access to the [`css_module` helper](https://github.com/joelmoss/proscenium?tab=readme-ov-file#in-your-views) if you need it. However, there is a better and more seemless way to reference CSS module classes in your Phlex classes.

Within your Phlex classes, any class names that begin with `@` will be treated as a CSS module class.

```ruby
# /app/views/users/show_view.rb
class Users::ShowView < Phlex::HTML
  include Proscenium::Phlex::CssModules # <--

  def view_template
    h1 class: :@user_name do
      @user.name
    end
  end
end
```

```css
/* /app/views/users/show_view.module.css */
.userName {
  color: red;
  font-size: 50px;
}
```

In the above `Users::ShowView` Phlex class, the `@user_name` class will be resolved to the `userName` class in the `users/show_view.module.css` file.

The view above will be rendered something like this:

```html
<h1 class="user_name-ABCD1234"></h1>
```

You can of course continue to reference regular class names in your view, and they will be passed through as is. This will allow you to mix and match CSS modules and regular CSS classes in your views.

```ruby
# /app/views/users/show_view.rb
class Users::ShowView < Phlex::HTML
  include Proscenium::Phlex::Sideload

  def view_template
    h1 class: :[@user_name, :title] do
      @user.name
    end
  end
end
```

```html
<h1 class="user_name-ABCD1234 title">Joel Moss</h1>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rails test` to run the tests, or `bundle exec appraisal rails test` to run them against every supported Phlex and Rails combination. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Releasing

Releases are published to [rubygems.org](https://rubygems.org) by the `release` GitHub Actions workflow, using trusted publishing, so no API key or one-time code is needed.

1. Update the version number in `lib/proscenium/phlex/version.rb`, run `bundle install && bundle exec appraisal install` to update every lockfile, and commit. CI installs gems in frozen mode, so a lockfile left on the old version fails the build.
2. Push a tag matching the new version:

   ```sh
   git tag v0.7.0
   git push origin master v0.7.0
   ```

The workflow checks that the tag matches the version, runs the tests, builds the gem and pushes it. If a run fails partway, re-run it: a version already on RubyGems is skipped.

Don't use `bundle exec rake release`. It pushes the gem from your machine, and the workflow then has nothing to publish.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joelmoss/proscenium-phlex.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
