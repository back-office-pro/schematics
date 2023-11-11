# frozen_string_literal: true

describe 'Gemfile template' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/app/templates/Gemfile.tt',
                  '5e8961cb4863d50977649e05b574d4caef46a4af0d5dd523a8200ff1e572c5b7'
end
