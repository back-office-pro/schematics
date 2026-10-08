# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/active_record/migration/migration_generator'

describe ActiveRecord::Generators::MigrationGenerator do
  it_behaves_like 'a monkey patched instance method',
                  :set_local_assigns!,
                  '67b334c2aedfb275c26d0e629a52a7305a2d566efa751e1d39d306cb6a0c4ae5'

  it_behaves_like 'a monkey patched instance method',
                  :migration_template,
                  '3730db7c5782c1f774ec18fa878b923c5b8561182c598e52b6b6f24a75df3db5'

  it_behaves_like 'a monkey patched instance method',
                  :db_migrate_path,
                  '959b0e1c80da9948a66f61d3d9ee4d810608f5fcd8c025f094b67ffbc1fb7eeb'

  it_behaves_like 'a monkey patched instance method',
                  :validate_file_name!,
                  'eca51b54e08b64a898d97ade83038160e2b689ecfb29fa1c3310f8030192fbf8'
end
