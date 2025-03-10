# Glimmer Web Components
## [<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer/master/images/glimmer-logo-hi-res.png" height=40 />Glimmer Web Components](https://github.com/AndyObtiva/glimmer-dsl-web)
[![Gem Version](https://badge.fury.io/rb/glimmer-web-components.svg)](http://badge.fury.io/rb/glimmer-web-components)
[![Join the chat at https://gitter.im/AndyObtiva/glimmer](https://badges.gitter.im/AndyObtiva/glimmer.svg)](https://gitter.im/AndyObtiva/glimmer?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This is a collection of reusable Glimmer Web Components for Glimmer DSL for Web, extracted from real Rails web applications.

## Setup

```
gem install glimmer-web-components
```

## Usage

### Multi Checkbox Dropdown:

![multi checkbox dropdown](/screenshots/glimmer-web-components-multi-checkbox-dropdown.png)

Add the following at the top:

```ruby
require 'glimmer/web/component/multi_checkbox_dropdown'
```

Then use the `multi_checkbox_dropdown` Glimmer Web Component in standard Glimmer HTML DSL code:

```ruby
  ...
  markup {
    div {
      ...
      multi_checkbox_dropdown(
        values: SomePresenter::STATUS_FILTER_TYPES,
        display_values: SomePresenter::STATUS_FILTER_TYPES.map { |value| I18n.t("status.#{value}") },
        locale: I18n.locale,
        width: 190,
        translations: {
          en: {select: I18n.t('form.status_filter', locale: :en)},
          es: {select: I18n.t('form.status_filter', locale: :es)},
        },
      ) {
        selected_values <=> [@some_presenter, :status_filters]
      }
      ...
    }
  }
  ...
```

## Help

## Issues

You may submit [issues](https://github.com/AndyObtiva/glimmer-dsl-web/issues) on [GitHub](https://github.com/AndyObtiva/glimmer-dsl-web/issues).

[Click here to submit an issue.](https://github.com/AndyObtiva/glimmer-dsl-web/issues)

## Chat

If you need live help, try to [![Join the chat at https://gitter.im/AndyObtiva/glimmer](https://badges.gitter.im/AndyObtiva/glimmer.svg)](https://gitter.im/AndyObtiva/glimmer?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Feature Suggestions

These features have been suggested. You might see them in a future version of Glimmer. You are welcome to contribute more feature suggestions.

[TODO.md](TODO.md)

## Change Log

[CHANGELOG.md](CHANGELOG.md)

## Contributing

[CONTRIBUTING.md](CONTRIBUTING.md)

## Contributors

* [Andy Maleh](https://github.com/AndyObtiva) (Founder)

[Click here to view contributor commits.](https://github.com/AndyObtiva/glimmer-web-components/graphs/contributors)

## License

[MIT](https://opensource.org/licenses/MIT)

Copyright (c) 2025 - Andy Maleh.
See [LICENSE.txt](LICENSE.txt) for further details.

--

[<img src="https://raw.githubusercontent.com/AndyObtiva/glimmer/master/images/glimmer-logo-hi-res.png" height=40 />](https://github.com/AndyObtiva/glimmer) Built for [Glimmer](https://github.com/AndyObtiva/glimmer) (DSL Framework).
