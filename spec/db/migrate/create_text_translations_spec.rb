# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'mobility'

describe 'Mobility text translations migration file' do
  it_behaves_like 'an overridden file',
                  :mobility,
                  '/lib/rails/generators/mobility/templates/create_text_translations.rb',
                  '4137ed10f7b75a51f819933f7674bb17e0f18ae1e4c148abd790de83d9224042'
end
