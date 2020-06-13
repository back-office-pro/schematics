module Schematics
  class ValidatorsCell < Cell::ViewModel
    self.view_paths = ["#{Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
    include ActionView::Helpers::NumberHelper
    property :validators
    BLACKLIST = [:presence, :attached].freeze

    def humanize_validators(list: validators)
      list.except(*BLACKLIST).map do |key, value|
        [
          i18n_key(key),
          case value
          when Array
            value.map(&:to_s).map(&:upcase).join(" ")
          when Hash
            humanize_validators(list: value)
          when Numeric
            number_to_human_size(value)
          else
            value.humanize
          end,
        ]
      end
    end

    private

    def i18n_key(key)
      I18n.t(key.to_sym, scope: 'schematics.application.form.attachment.validators')
    end
  end
end
