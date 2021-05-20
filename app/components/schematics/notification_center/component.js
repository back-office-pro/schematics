$(document).on('turbolinks:load', function() {
    $('#notifications-dropdown').has('.badge.badge-danger').on('click', function() {
        $(this).find('.badge.badge-danger').fadeOut();
        $.post('/dashboard/read_notifications');
    });
});
