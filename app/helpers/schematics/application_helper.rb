module Schematics
  module ApplicationHelper
    include Pagy::Frontend
    include FontAwesome5::Rails::IconHelper

    def setting(key)
      Rails.cache.fetch("settings_#{key}") do
        Setting.instance.send(key)
      end
    end

    def image_tag_representation(attachment, width: 800, height: 600, css_class: nil)
      representation = attachment.representation(resize_to_fit: [width, height]).processed
      image_tag main_app.url_for(representation), class: css_class
    rescue MiniMagick::Error
      I18n.t('errors.messages.image_metadata_missing').humanize
    rescue ActiveStorage::FileNotFoundError
      I18n.t('titles.schematics.schema.not_found')
    end

    def user_avatar(user)
      if user.avatar.attached?
        image_tag_representation(
          user.avatar,
          width: 36,
          height: 36,
          css_class: "rounded-circle border shadow-sm"
        )
      else
        fa_icon(:user_circle, size: "2x", class: "align-middle")
      end
    end
  end
end
