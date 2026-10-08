# frozen_string_literal: true

Schematics::Navbar::MessageCenter::Preview::SLIM = <<~SLIM
  .dropdown-item
    .row {
      data-action='click->application#visit'
      data-application-href-param=href
      role='button'
    }
      .col-auto.align-self-center
        = __avatar(user: author)
      .col.text-truncate
        div class=css_class = subject
        .text-body-tertiary data-controller='timeago' datetime=created_at
SLIM
