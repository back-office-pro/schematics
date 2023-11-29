# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  include Schematics::Specs::Model

  it { is_expected.not_to be_admin }
  it { is_expected.not_to be_online }

  it 'sends a mail after create' do
    expect { record.save! }
      .to have_enqueued_mail(Schematics::UserMailer, :new_account)
      .with(record)
      .on_queue('mailers')
  end
end
