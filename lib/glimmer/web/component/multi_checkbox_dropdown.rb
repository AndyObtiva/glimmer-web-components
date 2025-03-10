require 'glimmer-dsl-web'

require 'facets/hash/deep_merge'

module Glimmer
  module Web
    module Component
      class MultiCheckboxDropdown
        include Glimmer::Web::Component
        
        TRANSLATIONS_DEFAULT = {
          en: {
            select: 'Select',
            items_selected: 'items selected',
          },
          fr: {
            select: 'Sélectionnez',
            items_selected: 'articles sélectionnés',
          },
          es: {
            select: 'Seleccione',
            items_selected: 'artículos seleccionados',
          },
        }
        
        SELECTED_VALUES_FORMATTER_DEFAULT = ->(multi_checkbox_dropdown) {
          selected_value_count = multi_checkbox_dropdown.selected_values&.size.to_i
          case selected_value_count
          when 0
            multi_checkbox_dropdown.locale_translations[:select]
          when 1, 2
            multi_checkbox_dropdown.selected_display_values.join(', ')
          else
            items_selected_translation = multi_checkbox_dropdown.locale_translations[:items_selected]
            "#{selected_value_count} #{items_selected_translation}"
          end
        }
        
        REGEXP_LOCALE_COUNTRY = /-|_/
        
        CSS_CLASS_CONTENT_HIDDEN = "#{MultiCheckboxDropdown.component_element_class}-content-hidden"
        CSS_CLASS_CONTENT_UL = "#{MultiCheckboxDropdown.component_element_class}-ul"
        
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
        
        attr_accessor :display_content
        
        event :change # enables consumers to hook an on_change do; end listener
        
        before_render do
          self.display_values ||= values
          self.translations = TRANSLATIONS_DEFAULT.deep_merge(translations)
          self.display_content = false
        end
        
        after_render do
          setup_observer_so_clicking_outside_displayed_content_closes_content
        end
      
        markup {
          div(style: {position: :relative}) {
            multi_checkbox_select
            multi_checkbox_content
          }
        }
        
        style { # static global CSS styles shared between all instances of this component
          rule(".#{CSS_CLASS_CONTENT_HIDDEN}") {
            display :none
          }
        }
        
        def locale_translations
          the_translations = translations[locale.to_s.downcase.to_sym]
          if the_translations.nil? && locale.to_s.match(REGEXP_LOCALE_COUNTRY)
            # treat fr-CA as fr, or en-US as en
            partial_locale = locale.to_s.split(REGEXP_LOCALE_COUNTRY).first.downcase.to_sym
            the_translations = translations[partial_locale]
          end
          the_translations || {}
        end
        
        def selected_indexes
          selected_values.map { |selected_value| values.index(selected_value) }
        end
        
        def selected_display_values
          selected_indexes.map { |selected_index| display_values[selected_index] }
        end
        
        def display_value_for(value)
          display_values[values.index(value)]
        end
        
        def toggle_content(display = nil)
          new_value = display.nil? ? !self.display_content : display
          self.display_content = new_value
        end
        
        private
        
        def multi_checkbox_select
          @multi_checkbox_select = select(style: {height:, width:, margin:, text_align:}) {
            content(self, :selected_values) { # re-renders automatically upon change to self.selected_values
              placeholder_option_text = formatted_selected_values
              option(value: placeholder_option_text) {
                placeholder_option_text
              }
            }
            
            onkeydown do |event|
              case event.key_code
              when 40 # down
                event.prevent_default
                self.display_content = true if !self.display_content
              when 32 # space
                event.prevent_default
                toggle_content
              when 27 # escape
                event.prevent_default
                self.display_content = false
              end
            end
            
            onmousedown do |event|
              event.prevent_default
              toggle_content
            end
          }
        end
          
        def formatted_selected_values
          selected_values_formatter.call(self)
        end
        
        def multi_checkbox_content
          @multi_checkbox_content = div(style: {position: :absolute, z_index: content_z_index, width:, background: content_background, box_shadow: '0 6px 12px rgba(0, 0, 0, 0.175)'}) {
            class_name(CSS_CLASS_CONTENT_HIDDEN) <= [self, :display_content, on_read: :!]
            
            content(self, :selected_values) { # re-renders automatically upon change to self.selected_values
              ul(class: CSS_CLASS_CONTENT_UL, style: {list_style_type: :none, padding_top: 10, padding_left: 0}) {
                style { # dynamic CSS styles per component instance, so created before being used in li elements below
                  rule("ul.#{CSS_CLASS_CONTENT_UL} li:hover") {
                    background content_checkbox_option_hover_color
                  }
                }
                
                action_bar_li
                
                values.each do |value|
                  value_checkbox_li(value)
                end
              }
            }
          }
        end
        
        def action_bar_li
          are_all_values_selected = (values & selected_values) == values
          
          li(class: "#{MultiCheckboxDropdown.component_element_class}-li-select-all-values",
             style: {background: content_checkbox_option_hover_color, padding: '10px 0'}) {
            button(type: 'button', class: 'p-multiselect-close p-link',
                   style: {float: :right, margin_top: -5, margin_right: 10},
                   'aria-label': 'Close', 'data-pc-section': 'closebutton') {
              close_x_icon_svg
              
              onclick do
                self.display_content = false
              end
            }
            
            input(type: 'checkbox', value: are_all_values_selected,
                  style: {width: content_checkbox_size, height: content_checkbox_size,
                  display: :block, vertical_align: :middle,
                  margin_left: content_label_padding_px*2}) { |input_object|
              checked are_all_values_selected
              
              onchange do |event|
                if are_all_values_selected
                  self.selected_values = []
                else
                  self.selected_values = values.dup
                end
                notify_listeners(:change, selected_values)
              end
            }
          }
        end
        
        def close_x_icon_svg
          svg(width: '14', height: '14', viewbox: '0 0 14 14', fill: 'none', xmlns: 'http://www.w3.org/2000/svg', class: 'p-icon p-multiselect-close-icon', 'aria-hidden': 'true', 'data-pc-section': 'closeicon') {
            path(d: 'M8.01186 7.00933L12.27 2.75116C12.341 2.68501 12.398 2.60524 12.4375 2.51661C12.4769 2.42798 12.4982 2.3323 12.4999 2.23529C12.5016 2.13827 12.4838 2.0419 12.4474 1.95194C12.4111 1.86197 12.357 1.78024 12.2884 1.71163C12.2198 1.64302 12.138 1.58893 12.0481 1.55259C11.9581 1.51625 11.8617 1.4984 11.7647 1.50011C11.6677 1.50182 11.572 1.52306 11.4834 1.56255C11.3948 1.60204 11.315 1.65898 11.2488 1.72997L6.99067 5.98814L2.7325 1.72997C2.59553 1.60234 2.41437 1.53286 2.22718 1.53616C2.03999 1.53946 1.8614 1.61529 1.72901 1.74767C1.59663 1.88006 1.5208 2.05865 1.5175 2.24584C1.5142 2.43303 1.58368 2.61419 1.71131 2.75116L5.96948 7.00933L1.71131 11.2675C1.576 11.403 1.5 11.5866 1.5 11.7781C1.5 11.9696 1.576 12.1532 1.71131 12.2887C1.84679 12.424 2.03043 12.5 2.2219 12.5C2.41338 12.5 2.59702 12.424 2.7325 12.2887L6.99067 8.03052L11.2488 12.2887C11.3843 12.424 11.568 12.5 11.7594 12.5C11.9509 12.5 12.1346 12.424 12.27 12.2887C12.4053 12.1532 12.4813 11.9696 12.4813 11.7781C12.4813 11.5866 12.4053 11.403 12.27 11.2675L8.01186 7.00933Z', fill: 'currentColor')
          }
        end
        
        def value_checkbox_li(value)
          is_value_selected = selected_values.include?(value)
          li_class = is_value_selected ? :selected : ''
          
          li(class: li_class) {
            input_id = "#{MultiCheckboxDropdown.component_element_class}-#{object_id}-input-#{value}"
            
            input(type: 'checkbox', id: input_id, value: is_value_selected,
                  style: {width: content_checkbox_size, height: content_checkbox_size,
                  display: :block, vertical_align: :middle, float: :left,
                  margin: content_label_padding_px, margin_left: content_label_padding_px*2}) { |input_object|
              checked is_value_selected
              
              onchange do |event|
                selected_value_changed(value, input_object.checked)
              end
            }
            
            label(for: input_id, style: {padding: content_label_padding_px, font_size: content_label_font_size,
                  display: :block, vertical_align: :middle, width: 100.%}) {
              display_value_for(value)
            }
          }
        end
        
        def selected_value_changed(value, selected)
          new_selected_values = selected_values.dup
          if selected
            new_selected_values << value
          else
            new_selected_values.delete(value)
          end
          new_selected_values.sort_by! { |value| values.index(value) }
          self.selected_values = new_selected_values
          notify_listeners(:change, selected_values)
        end
        
        def setup_observer_so_clicking_outside_displayed_content_closes_content
          Element['body'].on('click') do |event|
            x = event.page_x || event.touch_x
            y = event.page_y || event.touch_y
            if display_content && location_outside_element?(x, y, @multi_checkbox_select) && location_outside_element?(x, y, @multi_checkbox_content)
              event.prevent_default
              self.display_content = false
            end
          end
        end
        
        def location_inside_element?(x, y, element)
          element_bounding_box = element.get_bounding_client_rect
          x.between?(element_bounding_box.left, element_bounding_box.left + element_bounding_box.width) &&
            y.between?(element_bounding_box.top, element_bounding_box.top + element_bounding_box.height)
        end
        
        def location_outside_element?(x, y, element)
          !location_inside_element?(x, y, element)
        end
      end
    end
  end
end
