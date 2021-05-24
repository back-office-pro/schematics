# frozen_string_literal: true

ActiveSupport.on_load(:action_text_rich_text) do
  ActionText::RichText.class_eval do
    acts_as_paranoid
  end
end
