module Schematics
  module ResourcesHelper
    def resource_associations(only_required: false)
      @resource_associations ||= attachments_attributes
                                 .concat(associations(only_required))
                                 .reject(&:empty?)
    end

    def confirm_data
      {
        'confirm': t('schematics.application.delete.title'),
        'text': t('schematics.application.delete.subtitle'),
        'confirm-button-text': t('schematics.application.form.buttons.confirm'),
        'cancel-button-text': t('schematics.application.form.buttons.cancel'),
        'sweet-alert-type': 'error',
        'allow-outside-click': false,
        'custom-class': ('disable-animation' if Rails.env.test?),
      }
    end

    private

    def attachments_attributes
      @attachments_attributes ||= entity
                                  .attachments_attributes
                                  .map do |attribute|
        resource
          .instance_eval(attribute.name)
          .includes(:blob)
      end
    end

    def associations(only_required)
      @associations ||= entity
                        .has_many_and_through_and_belongs_to_many_associations
                        .take_while { |association| !(only_required && !association.required?) }
                        .map do |association|
        resource
          .instance_eval(association.name)
          .includes(association.entity.includes)
          .accessible_by(current_ability)
      end
    end
  end
end
