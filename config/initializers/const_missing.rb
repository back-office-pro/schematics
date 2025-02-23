# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

def Demo.const_missing(name)
  schema = ::SchemaCache.cache('demo')
  entity = schema.find_entity_by_name(name.to_s.underscore)
  return unless entity

  unless const_defined?(name)
    Rails.logger.info "Loading #{name}..."
    eval(entity, binding, __FILE__, __LINE__) # rubocop:disable Security/Eval
  end

  const_get(name)
end
