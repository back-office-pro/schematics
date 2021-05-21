$(document).on('turbolinks:load', function() {
    $('#notifications-dropdown').has('.badge.badge-danger').on('click', function() {
        $(this).find('.badge.badge-danger').fadeOut();
        $(this).find('.animate__animated').removeClass('animate__animated');
        $.post('/dashboard/read_notifications');
    });
});
