require 'rails/generators/generated_attribute'
require 'rails/generators/actions'

Rails::Generators::GeneratedAttribute.singleton_class.
  prepend(Schematics::Patches::Rails::Generators::GeneratedAttribute)
Rails::Generators::GeneratedAttribute.
  prepend(Schematics::Patches::Rails::Generators::GeneratedAttribute)
Rails::Generators::Actions.
  prepend(Schematics::Patches::Rails::Generators::Actions)
