# frozen_string_literal: true

require 'rails'

describe 'Rails Scaffold Controller template' do
  it_behaves_like 'an overridden file',
                  :railties,
                  '/lib/rails/generators/rails/scaffold_controller/templates/controller.rb.tt',
                  'c665ff399163f09ec6cabc6c33b541647030c9c9b69480933864223ddc2e69cc'
end
