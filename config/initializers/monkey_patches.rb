require 'rails/generators/generated_attribute'
require 'rails/generators/actions'
require 'ransack/helpers/form_helper'
require 'ransack/nodes/sort'

Rails::Generators::GeneratedAttribute.singleton_class.
  prepend(Schematics::Patches::Rails::Generators::GeneratedAttribute)
Rails::Generators::GeneratedAttribute.
  prepend(Schematics::Patches::Rails::Generators::GeneratedAttribute)
Rails::Generators::Actions.
  prepend(Schematics::Patches::Rails::Generators::Actions)
Ransack::Helpers::FormHelper::SortLink.
  prepend(Schematics::Patches::Ransack::Helpers::FormHelper::SortLink)
Ransack::Nodes::Sort.prepend(Schematics::Patches::Ransack::Nodes::Sort)
