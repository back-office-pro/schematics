module Schematics
  module Behaviours
    module Migratable
      def type
        self.class.name.demodulize.underscore
      end

      def id
        [entity.name, name].join('_')
      end

      def to_s
        "schema:#{id}"
      end

      def options_for_migration
        options.slice(*migration_options)
      end

      def column_name
        name
      end

      protected

      def migration_options
        []
      end
    end
  end
end
