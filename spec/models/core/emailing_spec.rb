# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Emailing do
  include Schematics::Specs::Model

  its(:serializers) { is_expected.to be_empty }

  it 'sends a mail after create' do
    expect { record.save! }
      .to have_enqueued_mail(Schematics::EmailingMailer, :dispatch)
      .with(params: { shard: :default }, args: [record.id, record.recipients.first.id])
      .on_queue('default')
  end
end
