part of ondart;

class Contact extends ConceptEntity<Contact> {
  String _first_name;
  String _last_name;
  String _email;
  String _cell_number;

  String get first_name =>
      _first_name; /*block to get the value of first_name into string*/
  set first_name(String first_name) {
    var oldValue = _first_name;
    _first_name = first_name;
    notifyReactions(Action.UPDATE, this, "first_name", oldValue);
  }

  String get last_name =>
      _last_name; /*block to get the value of last_name into string*/
  set last_name(String last_name) {
    if (code == null) {
      code = last_name;
    }
    if (code == last_name) {
      _last_name = last_name;
    }
  }

  String get email => _email; /*block to get the value of email into string*/
  set email(String email) {
    if (code == null) {
      code = email;
    }
    if (code == email) {
      _email = email;
    }
  }

  String get cell_number =>
      _cell_number; /*block to get the value of cell_number into string*/
  set cell_number(String cell_number) {
    if (code == null) {
      code = cell_number;
    }
    if (code == cell_number) {
      _cell_number = cell_number;
    }
  }

  Contact newEntity() => new Contact();

  Map<String, Object> toJson() {
    Map<String, Object> entityMap = super.toJson();
    entityMap['first_name'] = first_name;
    entityMap['last_name'] = last_name;
    entityMap['email'] = email;
    entityMap['cell_number'] = cell_number;

    return entityMap;
  }

  fromJson(Map<String, Object> entityMap) {
    super.fromJson(entityMap);
    first_name = entityMap['first_name'];
    last_name = entityMap['last_name'];
    email = entityMap['email'];
    cell_number = entityMap['cell_number'];
  }
}

class Contacts extends ConceptEntities<Contact> {
  Contacts newEntities() => new Contacts();
  Contact newEntity() => new Contact();
}
