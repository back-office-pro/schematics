# frozen_string_literal: true

Rails.configuration.to_prepare do
  if defined?(ActiveStorage)
    ActiveStorage.singleton_class.module_eval do
      def use_relative_model_naming?
        false
      end
    end

    ActiveStorage::Record.include(Schematics::Loadable)
  end
end
