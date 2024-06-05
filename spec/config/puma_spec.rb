# frozen_string_literal: true

describe 'Puma config file' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/config/puma.rb.tt',
                  '33ebf59e623d413c5a01ee8ad31c3c47997c5e89cb74f925047bbf18ade9cc3a'
end
