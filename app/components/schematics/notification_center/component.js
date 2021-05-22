$(document).on('turbolinks:load', function() {
    $('#notifications-dropdown').has('.badge.badge-danger').on('click', function() {
        $element = $(this);
        $.post('/dashboard/read_notifications', function() {
            $element
                .find('.badge.badge-danger')
                .fadeOut()
                .end()
                .find('.animate__animated')
                .removeClass('animate__animated');
        });
    });
});
