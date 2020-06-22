ActiveSupport.on_load(:action_text_rich_text) do
  ActionText::RichText.class_eval do
    acts_as_paranoid
    # has_paper_trail only: [:body],
    #                 meta: { item_type: :record_type, item_id: :record_id }
  end
end
