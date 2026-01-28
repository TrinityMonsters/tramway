import { Controller } from "@hotwired/stimulus"

export default class Multiselect extends Controller {
  static targets = ["dropdown", "showSelectedArea", "hiddenInput", "caretDown", "caretUp"]

  static values = {
    items: Array,
    dropdownContainer: String,
    itemContainer: String,
    selectedItemTemplate: String,
    dropdownState: String,
    selectedItems: Array,
    placeholder: String,
    selectAsInput: String,
    value: Array,
    onChange: String
  }

  connect() {
    this.dropdownState = 'closed';
    this.items = JSON.parse(this.element.dataset.items).map((item, index) => {
      return {
        index,
        text: item.text,
        value: item.value.toString(),
        selected: false
      }
    });

    const initialValues = this.element.dataset.value === undefined ? [] : JSON.parse(this.element.dataset.value);

    initialValues.map((value) => {
      const itemIndex = this.items.findIndex(x => x.value.toString() === value.toString());
      this.items[itemIndex].selected = true;
    })

    this.selectedItems = this.items.filter(item => item.selected);

    this.renderSelectedItems();
  }

  renderSelectedItems() {
    const allItems = this.fillTemplate(this.element.dataset.selectedItemTemplate, this.selectedItems);

    this.showSelectedAreaTarget.innerHTML = allItems;
    this.showSelectedAreaTarget.insertAdjacentHTML("beforeEnd", this.input());
    this.updateInputOptions();
  }

  fillTemplate(template, items) {
    return items.map((item) => {
      return template.replace(/{{text}}/g, item.text).replace(/{{value}}/g, item.value)
    }).join('')
  }

  closeOnClickOutside(event) {
    if (this.dropdownState === 'open' && !this.element.contains(event.target)) {
      this.closeDropdown();
    }
  }

  toggleDropdown() {
    if (this.dropdownState === 'closed') {
      this.openDropdown();
    } else {
      this.closeDropdown();
    }

  }

  rerenderItems() {
    this.closeDropdown();
    this.openDropdown();
  }

  openDropdown() {
    this.dropdownState = 'open';
    this.dropdownTarget.insertAdjacentHTML("afterend", this.template);

    if (this.dropdown()) {
      this.dropdown().addEventListener('click', event => event.stopPropagation());
    }

    this.caretDownTarget.classList.add('hidden');
    this.caretUpTarget.classList.remove('hidden');
  }

  dropdown() {
    return this.element.querySelector('#dropdown');
  }

  closeDropdown() {
    this.dropdownState = 'closed';
    if (this.dropdown()) {
      this.dropdown().remove();
    }

    const onChange = this.element.dataset.onChange;

    if (onChange) {
      const [controllerName, actionName] = onChange.split('#');
      const controller = this.application.controllers.find(controller => controller.identifier === controllerName)

      if (controller) {
        if (typeof controller[actionName] === 'function') {
          controller[actionName]({ target: this.element });
        } else {
          alert(`Action not found: ${actionName}`); // eslint-disable-line no-undef
        }
      } else {
        alert(`Controller not found: ${controllerName}`); // eslint-disable-line no-undef
      }
    }

    this.caretDownTarget.classList.remove('hidden');
    this.caretUpTarget.classList.add('hidden');
  }

  get template() {
    return this.element.dataset.dropdownContainer.replace(
      /{{content}}/g,
      this.fillTemplate(this.element.dataset.itemContainer, this.items.filter(item => !item.selected))
    );
  }

  toggleItem({ currentTarget }) {
    const itemIndex = this.items.findIndex(x => x.value === currentTarget.dataset.value);
    const itemSelectedIndex = this.selectedItems.findIndex(x => x.value === currentTarget.dataset.value);

    if (itemSelectedIndex !== -1) {
      this.selectedItems = this.selectedItems.filter((_, index) => index !== itemSelectedIndex);
      this.items[itemIndex].selected = false; 
    } else {
      this.selectedItems.push(this.items[itemIndex]);
      this.items[itemIndex].selected = true;
    }

    this.renderSelectedItems();
    this.rerenderItems();
  }

  input() {
    const placeholder = this.selectedItems.length > 0 ? '' : this.element.dataset.placeholder;
    return this.element.dataset.selectAsInput.replace(/{{placeholder}}/g, placeholder);
  }

  updateInputOptions() {
    this.hiddenInputTarget.innerHTML = '';
    this.selectedItems.forEach(selected => {
      const option = document.createElement("option");
      option.text = selected.text;
      option.value = selected.value;
      option.setAttribute("selected", true);
      this.hiddenInputTarget.append(option);
    });

    this.hiddenInputTarget.value = this.selectedItems.map(item => item.value);
  }
}

export { Multiselect }
