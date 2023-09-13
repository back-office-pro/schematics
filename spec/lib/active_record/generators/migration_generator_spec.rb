# frozen_string_literal: true

require 'digest'
require 'method_source'
require 'rails/generators'
require 'rails/generators/active_record/migration/migration_generator'

describe ActiveRecord::Generators::MigrationGenerator do
  describe '#set_local_assigns!' do
    subject do
      Digest::SHA256.hexdigest(described_class.instance_method(:set_local_assigns!).source)
    end

    it { is_expected.to eq('67b334c2aedfb275c26d0e629a52a7305a2d566efa751e1d39d306cb6a0c4ae5') }
  end
end
