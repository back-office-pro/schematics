# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Shards
    class Reload
      include Interactor
      delegate :old_and_changed_model_classes, to: :context, private: true

      def call
        old_and_changed_model_classes.each do |model_class|
          mod = model_class.deconstantize.safe_constantize || Object
          constant = model_class.demodulize
          mod.__send__(:remove_const, constant) if mod.const_defined?(constant)
        end
      end
    end
  end
end
