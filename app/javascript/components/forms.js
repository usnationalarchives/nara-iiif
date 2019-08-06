import {MDCTextField} from '@material/textfield/index';

const textFields = document.querySelectorAll('.mdc-text-field');

if (textFields.length) {
  [].forEach.call(textFields, function(field) {
    new MDCTextField(field);
  })
}
