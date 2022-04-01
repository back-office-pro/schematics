//= require jquery-ujs/src/rails
//= require sweetalert2/dist/sweetalert2

/* global $, Swal, I18n */

document.addEventListener('turbolinks:load', function () {
  $('[data-confirm]').on('click', function () {
    Swal.fire({
      title: I18n.sweetalert2.title,
      text: I18n.sweetalert2.text,
      icon: 'error',
      showCancelButton: true,
      confirmButtonText: I18n.sweetalert2.confirmButtonText,
      cancelButtonText: I18n.sweetalert2.cancelButtonText,
      allowOutsideClick: false,
      buttonsStyling: false,
      customClass: {
        confirmButton: 'btn btn-primary',
        cancelButton: 'btn btn-danger'
      }
    }).then(result => {
      if (result.isConfirmed) {
        $.rails.handleMethod($(this))
      }
    })
    return false
  })
})
