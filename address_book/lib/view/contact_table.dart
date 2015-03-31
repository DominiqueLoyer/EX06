part of ondart;

class ContactTable {
  Contacts contacts;
  Reaction react; 
  InputElement first_nameInput;
  InputElement last_nameInput;
  InputElement emailInput;
  InputElement cell_numberInput;
  ButtonElement addContact;
  TableElement contactTable;
  ButtonElement clearContacts;
  ButtonElement loadContacts;
  ButtonElement saveContacts;
  

  ContactTable() {
    contacts = new ContactModel().contacts;
    react = (Action action, [Contact contact, String propertyName, Object oldValue]) {
      switch (action) {
        case Action.ADD:
          addRowData(contact.first_name, contact.last_name, contact.email, contact.cell_number);
          first_nameInput.select();
          return true;
        case Action.CLEAR:
          contactTable.children.clear();
          first_nameInput.value = '';
          last_nameInput.value = '';
          emailInput.value ='';
          cell_numberInput.value ='';
          addTableCaption('Contacts');
          addColumnTitles();
          return true;
        case Action.REMOVE:
          var row = findRow(contact.first_name);
          row.remove();
          first_nameInput.value = '';
          last_nameInput.value = '';
          emailInput.value ='';
          cell_numberInput.value ='';
          return true;
        case Action.UPDATE:
          var row = findRow(contact.first_name);
          if (propertyName == "first_name") {
            row.children[0].text = contact.first_name;
            return true;
          }else if (propertyName == "last_name") {
            row.children[0].text = contact.last_name;
            return true;
          }else if (propertyName == "email") {
            row.children[0].text = contact.email;
            return true;
          }else if (propertyName == "cell_number") {
           row.children[0].text = contact.cell_number;
           return true;
          }else{
          return false;
          }
      }
    };
    
    contacts.startReaction(react);
    first_nameInput = document.querySelector('#first_name-input');
    first_nameInput.onChange.listen((e) {
      var value = first_nameInput.value;
      var contact = contacts.find(value);
      if (contact != null) {
        contact.first_name = first_nameInput.value;
      }
    });
    last_nameInput = document.querySelector('#last_name-input');
    emailInput = document.querySelector('#email-input');
    cell_numberInput = document.querySelector('#cell_number-input');
    
    
    addContact = document.querySelector('#add-contact');
    addContact.onClick.listen((e) {
      var contact = new Contact();
      contact.first_name = first_nameInput.value;
      contact.last_name = last_nameInput.value;
      contact.email = emailInput.value;
      contact.cell_number = cell_numberInput.value;     
      contact.startReaction(react);
      contacts.add(contact);
    });
    contactTable = document.querySelector('#contact-table');
    clearContacts = document.querySelector('#clear-notes');
    clearContacts.onClick.listen((e) {
      contacts.clear();
    });
    loadContacts = document.querySelector('#load-contacts');
    loadContacts.onClick.listen((e) {
      if (contacts.isEmpty) {
        contacts.fromJson(JSON.decode(window.localStorage['contacts']));
        contacts.forEach((contact) => contact.startReaction(react));
      }
    });
    saveContacts = document.querySelector('#save-contacts');
    saveContacts.onClick.listen((e) {
      window.localStorage['contacts'] = JSON.encode(contacts.toJson());
    });
    addTableCaption('Contacts');
    addColumnTitles();
  }

  addColumnTitle(row, String title, num width) {
    var columnHeader = new Element.th();
    columnHeader.text = title;
    columnHeader.style.width = '${width}%';
    row.children.add(columnHeader);
  }

  addColumnTitles() {
    var row = new Element.tr();
    contactTable.children.add(row);
    addColumnTitle(row, 'Prenom', 24);
    addColumnTitle(row, 'Nom de Famille', 24);
    addColumnTitle(row, 'Courriel', 24);
    addColumnTitle(row, 'Cellulaire', 24);
    addColumnTitle(row, 'Supprimer', 4);
  }

  addRowData(String first_name, String last_name, String email, String cell_number) {
    var contactRow = new Element.tr();
    var first_nameCell = new Element.td();
    var last_nameCell = new Element.td();
    var emailCell = new Element.td();
    var cell_numberCell = new Element.td();
    var removeCell = new Element.td();
    first_nameCell.style.width = '24%';
    last_nameCell.style.width = '24%';
    emailCell.style.width = '24%';
    cell_numberCell.style.width = '24%';
    removeCell.style.width = '4%';
    
    first_nameCell.text = first_name;
    last_nameCell.text = last_name;
    emailCell.text = email;
    cell_numberCell = cell_number;
    removeCell.text = 'X';
    contactTable.children.add(contactRow);
    contactRow.children.add(first_nameCell);
    contactRow.children.add(last_nameCell);
    contactRow.children.add(emailCell);
    contactRow.children.add(cell_numberCell);
    contactRow.children.add(removeCell);
    first_nameCell.onClick.listen((e) {
      first_nameInput.value = first_nameCell.text;
      last_nameInput.value = last_nameCell.text;
      emailInput.value = emailCell.text;
      cell_numberInput.value = cell_numberCell.text;
    });
    removeCell.onClick.listen((e) {
      contacts.remove(contacts.find(first_nameCell.text));
    });
  }

  addTableCaption(String title) {
    var contactTableCaption = contactTable.createCaption();
    contactTableCaption.text = title;
    contactTable.caption = contactTableCaption;
  }

  TableRowElement findRow(String contact) {
    var r = 0;
    for (var row in contactTable.children) {
      if (row is TableRowElement && r++ > 0) {
        if (row.children[1].text == contact) {
          return row;
        }
      }
    }
    return null;
  }
}


