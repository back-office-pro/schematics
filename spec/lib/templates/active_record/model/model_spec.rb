# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_record'

describe 'Rails Model template' do
  it_behaves_like 'an overridden file',
                  :activerecord,
                  '/lib/rails/generators/active_record/model/templates/model.rb.tt',
                  '7ee9c82add51b77111716f6022bdf0d2b6c5535608691ec79279975f508b5340'
end
