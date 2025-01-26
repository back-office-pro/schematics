# frozen_string_literal: true

def Object.const_missing(name)
  entity = SchemaCache.find_entity_by_name(name.to_s.underscore)
  return super unless entity

  path = Schematics::Engine.root.join('app', 'models', 'core', "#{entity.name}.rb")

  if path.exist?
    load(path)
  else
    eval(entity, binding, __FILE__, __LINE__) # rubocop:disable Security/Eval
  end

  const_get(name)
end
