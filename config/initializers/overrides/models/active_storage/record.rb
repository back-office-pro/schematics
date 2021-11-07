# frozen_string_literal: true

ActiveSupport.on_load(:active_storage_record) do
  ActiveStorage::Record.class_eval do
    include Schematics::Loadable
    loadable concerns: [Schematics::Elasticsearchable, Schematics::SoftDeletable]
  end
end
