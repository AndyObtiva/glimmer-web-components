require 'opal'

GLIMMER_WEB_COMPONENTS_ROOT = File.expand_path('../..', __FILE__)
GLIMMER_WEB_COMPONENTS_LIB = File.join(GLIMMER_WEB_COMPONENTS_ROOT, 'lib')
 
$LOAD_PATH.unshift(GLIMMER_WEB_COMPONENTS_LIB)

if RUBY_ENGINE == 'opal'
  require 'glimmer/web/component/multi_checkbox_dropdown'
end
