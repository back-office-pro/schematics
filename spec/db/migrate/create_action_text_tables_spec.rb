# frozen_string_literal: true

require 'action_text'

describe 'ActionText migration file' do
  it_behaves_like 'an overridden file',
                  :actiontext,
                  '/db/migrate/20180528164100_create_action_text_tables.rb',
                  'd1ed6e7cec840d3ee27b4c967858b30a14f343ac9888b920ad3d858594bfd8d5'
end
