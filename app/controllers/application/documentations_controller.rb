# frozen_string_literal: true

module Application
  module DocumentationsController
    extend ActiveSupport::Concern

    def key_transform = :unaltered

    def i18n_title_path = 'documentation'
  end
end
