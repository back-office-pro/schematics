# frozen_string_literal: true

def Object.const_missing(name)
  entity = Tenant.schema.find_entity_by_name(name.to_s.underscore)
  return super unless entity

  eval entity, binding, __FILE__, __LINE__ # rubocop:disable Security/Eval
  const_get(name)
end
