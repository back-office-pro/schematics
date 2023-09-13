# frozen_string_literal: true

describe 'ActionText migration file' do
  it_behaves_like 'an overridden file',
                  :actiontext,
                  '/db/migrate/20180528164100_create_action_text_tables.rb',
                  '9845fff887f84520682c734bbeaf75458214059834b608a1b5b8d8aff9048120'
end
