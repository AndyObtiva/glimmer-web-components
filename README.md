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

![multi checkbox dropdown](/screenshots/glimmer-web-components-multi-checkbox-dropdown.gif)

Add the following at the top:

```ruby
require 'glimmer/web/component/multi_checkbox_dropdown'
```

Then use the `multi_checkbox_dropdown` Glimmer Web Component in standard Glimmer HTML DSL code.

Simple version with `on_change` listener:

```ruby
  ...
  markup {
    div {
      ...
      multi_checkbox_dropdown(values: SomePresenter::STATUS_FILTER_TYPES) {
        on_change do |selected_values|
          # Do something with selected values
        end
      }
      ...
    }
  }
  ...
```

Simpler **(recommended)** version with bidirectional data-binding (`selected_values` are automatically prepopulated from `@some_presenter.status_filters` and stored back on `@some_presenter.status_filters` upon user selection):

```ruby
  ...
  markup {
    div {
      ...
      multi_checkbox_dropdown(values: SomePresenter::STATUS_FILTER_TYPES) {
        selected_values <=> [@some_presenter, :status_filters]
      }
      ...
    }
  }
  ...
```

Here is the list of defined `multi_checkbox_dropdown` component options for customization when needed:

```ruby
        option :values, default: []
        option :display_values
        option :selected_values, default: []
        option :locale, default: :en
        option :translations, default: {}
        option :selected_values_formatter, default: SELECTED_VALUES_FORMATTER_DEFAULT
        option :width, default: 175
        option :height, default: 40
        option :margin, default: '0 15px 0 0'
        option :text_align, default: :center
        option :content_z_index, default: '1000'
        option :content_label_padding_px, default: 10
        option :content_background, default: :white
        option :content_checkbox_size, default: 20
        option :content_checkbox_option_hover_color, default: 'rgb(245, 245, 245)'
        option :content_label_font_size, default: 1.rem
```

Here is a customized version of consuming the `multi_checkbox_dropdown` Glimmer Web Component:

```ruby
  ...
  markup {
    div {
      ...
      multi_checkbox_dropdown(
        values: SomePresenter::STATUS_FILTER_TYPES,
        display_values: SomePresenter::STATUS_FILTER_TYPES.map(&:capitalize),
        locale: I18n.locale,
        width: 190,
        translations: {
          en: {select: I18n.t('form.filter_by_status')},
          fr: {select: I18n.t('form.filter_by_status')},
          es: {select: I18n.t('form.filter_by_status')},
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
