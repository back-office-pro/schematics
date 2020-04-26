module Schematics
  module ApplicationHelper
    include FontAwesome5::Rails::IconHelper

    def setting(key)
      Setting.instance.send(key)
    end

    def title
      I18n.t :title, query: params[:query], scope: [
        :schematics,
        controller_name.to_sym,
        action_name.to_sym,
      ]
    end

    def humanize_attachment_validators(validators)
      content = []
      validators.except(:presence, :attached).each do |key, value|
        content << [
          I18n.t(key.to_sym, scope: 'schematics.application.form.attachment.validators'),
          case value
          when Array
            value.map(&:to_s).map(&:upcase).join(" ")
          when Hash
            humanize_attachment_validators(value)
          when Numeric
            number_to_human_size(value)
          else
            value.humanize
          end,
        ].join(" ")
      end
      content.join(" - ").html_safe
    end

    def image_tag_representation(attachment, width: 800, height: 600, css_class: nil)
      representation = attachment.representation(resize_to_fit: [width, height]).processed
      image_tag main_app.url_for(representation), class: css_class
    rescue MiniMagick::Error
      I18n.t('errors.messages.image_metadata_missing').humanize
    rescue ActiveStorage::FileNotFoundError
      I18n.t('schematics.schema.not_found.title')
    end

    def user_avatar(user)
      if user.avatar.attached?
        image_tag_representation(
          user.avatar,
          width: 36,
          height: 36,
          css_class: "rounded-circle border border-dark"
        )
      else
        fa_icon(:user_circle, size: "2x", class: "align-middle")
      end
    end
  end
end
