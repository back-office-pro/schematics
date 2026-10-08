# frozen_string_literal: true

Schematics::ResourceForm::Fields::RichText::SLIM = <<~SLIM
  - if translated?
    - available_locales.each do |locale|
      == required_rich_textarea :"\#{name}_\#{locale}", label: i18n_label(locale), data:, required:
  - else
    == required_rich_textarea name.to_sym, data:
SLIM
