//= require rails.validations
//= require rails.validations.simple_form.bootstrap4

ClientSideValidations.callbacks.element.pass = function(element, callback) {
    element.closest('form').find('button[type="submit"]').removeAttr('disabled');
    callback();
};

ClientSideValidations.callbacks.element.fail = function(element, message, callback) {
    element.closest('form').find('button[type="submit"]').attr('disabled', true);
    callback();
};
