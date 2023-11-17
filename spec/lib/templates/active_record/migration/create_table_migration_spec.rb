# frozen_string_literal: true

describe 'Rails create table migration template' do
  it_behaves_like 'an overridden file',
                  :activerecord,
                  '/lib/rails/generators/active_record/migration/templates/create_table_migration.rb.tt', # rubocop:disable Layout/LineLength
                  '0965e0feb1bdbc4fcf5b4d793785fdbc8b6675c7bac1de949a29260ebf633cd4'
end
