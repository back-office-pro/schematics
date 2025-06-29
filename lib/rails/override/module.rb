# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Rails
  module Override
    module Module
      def const_missing(name)
        eval(SchemaCache, binding, __FILE__, __LINE__) # rubocop:disable Security/Eval
        entity = SchemaCache.find_entity_by_name(name.to_s.underscore)
        return super unless entity

        unless self.name.constantize.const_defined?(name)
          Rails.logger.info "Loading #{name}..."
          path = Rails.root.join('app', 'models', 'core', "#{entity.name}.rb")

          if path.exist?
            load(path)
          else
            eval(entity, binding, __FILE__, __LINE__) # rubocop:disable Security/Eval
          end
        end

        const_get(name)
      end
    end
  end
end
