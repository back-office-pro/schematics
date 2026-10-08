# frozen_string_literal: true

Schematics::Navbar::OnlineUsersCenter::Preview::SLIM = <<~SLIM
  .dropdown-item
    .row {
      data-action='click->application#visit'
      data-application-href-param=href
      role='button'
    }
      .col-auto.align-self-center
        = __attachment(:avatar, user:)
      .col.text-truncate
        = user
        .text-body-tertiary data-controller='timeago' datetime=updated_at
SLIM
