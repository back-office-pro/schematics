# == Schema Information
#
# Table name: messages
#
#  id           :bigint           not null, primary key
#  deleted_at   :datetime
#  subject      :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  author_id    :bigint           not null
#  recipient_id :bigint           not null
#
# Indexes
#
#  index_messages_on_author_id     (author_id)
#  index_messages_on_recipient_id  (recipient_id)
#  index_messages_on_subject       (subject)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#  fk_rails_...  (recipient_id => users.id)
#

class Message < Schematics::ApplicationRecord
end
