# frozen_string_literal: true

Schematics::Navbar::MeetingCenter::Preview::SLIM = <<~SLIM
  .dropdown-item
    .row {
      data-action='click->application#visit'
      data-application-href-param=href
      role='button'
    }
      .col-auto.align-self-center
        = __avatar(user: creator)
      .col.text-truncate
        = subject
        .text-body-tertiary
          span data-controller='timeago' datetime=start_at
          - if location
            span.mx-1 -
            span = location
SLIM
