import { MDCTextField } from '@material/textfield';
import { MDCRipple } from '@material/ripple';
import { MDCSelect } from '@material/select';
import { MDCCheckbox } from '@material/checkbox';
import { MDCFormField } from '@material/form-field';
import { MDCDialog } from '@material/dialog';
import { MDCMenu } from '@material/menu';
import { MDCList } from '@material/list';
import { MDCDrawer } from '@material/drawer';
import { MDCTopAppBar } from '@material/top-app-bar';

// Initialize Material components when the DOM is loaded
document.addEventListener('turbo:load', () => {
  initializeMaterialComponents();
});

document.addEventListener('DOMContentLoaded', () => {
  initializeMaterialComponents();
});

function initializeMaterialComponents() {
  // Initialize text fields
  const textFieldElements = document.querySelectorAll('.mdc-text-field');
  textFieldElements.forEach(textFieldEl => {
    new MDCTextField(textFieldEl);
  });

  // Initialize buttons with ripple effect
  const buttonElements = document.querySelectorAll('.mdc-button');
  buttonElements.forEach(buttonEl => {
    new MDCRipple(buttonEl);
  });

  // Initialize select fields
  const selectElements = document.querySelectorAll('.mdc-select');
  selectElements.forEach(selectEl => {
    new MDCSelect(selectEl);
  });

  // Initialize checkboxes
  const checkboxElements = document.querySelectorAll('.mdc-checkbox');
  checkboxElements.forEach(checkboxEl => {
    const checkbox = new MDCCheckbox(checkboxEl);

    // If there's an associated form field
    const formFieldEl = checkboxEl.closest('.mdc-form-field');
    if (formFieldEl) {
      const formField = new MDCFormField(formFieldEl);
      formField.input = checkbox;
    }
  });

  // Initialize dialogs
  const dialogElements = document.querySelectorAll('.mdc-dialog');
  dialogElements.forEach(dialogEl => {
    new MDCDialog(dialogEl);
  });

  // Initialize other components as needed
}

// Custom JavaScript for search and filtering on admin dashboard
document.addEventListener('DOMContentLoaded', function() {
  const searchInput = document.getElementById('userSearchInput');
  const roleFilter = document.getElementById('roleFilter');
  const table = document.getElementById('usersTable');

  if (searchInput && roleFilter && table) {
    const rows = table.querySelectorAll('tbody tr');

    function filterTable() {
      const searchTerm = searchInput.value.toLowerCase();
      const roleValue = roleFilter.value.toLowerCase();

      rows.forEach(function(row) {
        const email = row.cells[0].textContent.toLowerCase();
        const role = row.getAttribute('data-role');

        const matchesSearch = email.includes(searchTerm);
        const matchesRole = !roleValue || role === roleValue;

        row.style.display = matchesSearch && matchesRole ? '' : 'none';
      });
    }

    searchInput.addEventListener('input', filterTable);
    roleFilter.addEventListener('change', filterTable);
  }
});
