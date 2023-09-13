# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/active_record/migration/migration_generator'

describe ActiveRecord::Generators::MigrationGenerator do
  it_behaves_like 'a monkey patched instance method',
                  :set_local_assigns!,
                  '67b334c2aedfb275c26d0e629a52a7305a2d566efa751e1d39d306cb6a0c4ae5'
end
