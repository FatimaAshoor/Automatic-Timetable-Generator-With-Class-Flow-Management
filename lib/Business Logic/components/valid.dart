//  ---------------------------------- Email Method ----------------------------------
validEmailInput(String value) {
  if (value.isEmpty) {
    return "This field can't be empty";
  }
  if (!_usernamePart(value)) {
    return "username should contain only alphanumeric characters and '-'";
  }

  if (!_middlePart(value)) {
    return "after @ should write 'hu.edu'";
  }
  if (!_lastPart(value)) {
    return "last part of email should be '.ye'";
  }
  return null;
}

_usernamePart(String email) {
  final localPartRegex = r'^[\w-]{1,15}$';
  return RegExp(localPartRegex).hasMatch(email.split('@').first);
}

_middlePart(String email) {
  final domainNameRegex = r'@hu\.(edu\.ye)$';
  return RegExp(domainNameRegex).hasMatch(email);
}

_lastPart(String email) {
  final tldRegex = r'\.ye$';
  return RegExp(tldRegex).hasMatch(email.split('@').last);
}



//  ---------------------------------- Password Method ----------------------------------
validatePassword(String value) {
  if (value.isEmpty) {
    return "This field can't be empty";
  }
  else if (value.length < 8) {
    return "Password must be at least 8 characters long";
  }
  else if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
    return "Password must contain at least one letter";
  }
  else if (!RegExp(r'\d').hasMatch(value)) {
    return "Password must contain at least one number";
  }
  else if (!RegExp(r'[!#$%&? "]').hasMatch(value)) {
    return "Password must contain at least one special character (!#%&? \")";
  }
  return null;
}



//  ---------------------------------- Characters Method ----------------------------------
validateCharacters(String value) {
  if (value.isEmpty) {
    return "This field can't be empty";
  }
  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
    return 'Please enter characters and spaces only.';
  }
  return null;
}


//  ---------------------------------- Numbers Method ----------------------------------
validateNumbers(String value) {
  if (value.isEmpty) {
    return "This field can't be empty";
  }
  if (!RegExp(r'^[0-9\s]+$').hasMatch(value)) {
    return 'Please enter numbers and spaces only.';
  }
  return null;
}


//  ---------------------------------- Numbers & Characters Method ----------------------------------
validateNumbersAndCharacters(String value) {
  if (value.isEmpty) {
    return "This field can't be empty";
  }
  if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
    return 'Please enter characters, numbers, and spaces only.';
  }
  return null;
}

//  ---------------------------------- Time Method ----------------------------------

validateTimeWith(value) {
  if (value.isEmpty) {
    return "This field can't be empty";
  }
  if (!RegExp(r'^([0-1][0-9]|2[0-3])[:][0-5][0-9]$').hasMatch(value)) {
    return 'Please enter a valid time format (HH:MM).';
  }
  return null;
}



//  ----------------- حق الحنبة -----------------
validEmailInput1(String? val){
  if (val!.isEmpty) {
    return "This Field Can't Be Empty";
  }
  final emailRegex = r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';
  if (!RegExp(emailRegex).hasMatch(val)) {
    return " Enter Valid Email";
  }
  return null;
}

validatePassword1(String value){
  if (value.isEmpty) {
    return "This Field Can't Be Empty";
  }
  final passwordRegex = r'^.*(?=.{8,})(?=.*[a-zA-Z])(?=.*\d)(?=.*[!#$%&? "]).*$';
  if (!RegExp(passwordRegex).hasMatch(value)) {
    return " Enter Valid password";
  }
  return null;
}