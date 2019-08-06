import {MDCTextField} from '@material/textfield/index';

const textFields = document.querySelectorAll('.mdc-text-field');

console.log(textFields);


[].forEach.call(textFields, function(field) {
  new MDCTextField(field);
})
