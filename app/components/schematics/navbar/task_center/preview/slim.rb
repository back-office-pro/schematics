# frozen_string_literal: true

Schematics::Navbar::TaskCenter::Preview::SLIM = <<~SLIM
  .dropdown-item
    .row {
      data-action='click->application#visit'
      data-application-href-param=href
      role='button'
    }
      .col-auto.align-self-center
        = __avatar(user: applicant)
      .col.text-truncate
        div class=css_class = title
        .text-body-tertiary
          span = state_formatted
          - if deadline
            spam.mx-1 -
            span data-controller='timeago' datetime=deadline
SLIM
