# frozen_string_literal: true

namespace :schematics do
  namespace :licence do
    desc 'Load licence from gateway'
    task load: :environment do
      Core::Licence.instance.load!
    end
  end
end
