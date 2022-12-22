# frozen_string_literal: true

namespace :schematics do
  namespace :licence do
    desc 'Load licence from gateway'
    task load: :environment do
      Licence.instance.load!
    end
  end
end
