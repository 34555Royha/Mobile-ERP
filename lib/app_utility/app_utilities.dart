import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppUtilities {
  static String getCurrentDate() {
    var dateTime = DateTime.now();
    var retVal = (DateFormat('yyyy-MM-dd').format(dateTime)).toString();
    return retVal;
  }

  static String getCurrentTime() {
    var td = DateTime.now();
    var retVal = DateFormat('HH:mm a').format(td);
    return retVal;
  }

  static Future<String> formatTimeTo24H(String pVal) async {
    if (pVal == "") {
      return pVal = "00:00";
    } else if (pVal.length == 5 || pVal.length > 8) {
      return pVal;
    }
    pVal = DateFormat("HH:mm").format(DateFormat.jm().parse(pVal));
    return pVal;
  }

  static Future<String> formatDateTimeTo12H(String dateTimeValue) async {
    if (dateTimeValue.isEmpty) {
      return dateTimeValue = "0:00";
    }
    DateFormat format = DateFormat('yyyy-MM-dd hh:mm:ss');
    DateTime x = format.parse(dateTimeValue);
    dateTimeValue = DateFormat.jm().format(x);
    return dateTimeValue;
  }

  static Future<String> formatTimeTo12H(String dateTimeValue) async {
    if (dateTimeValue.isEmpty) {
      return dateTimeValue = "0:00";
    }
    DateFormat format = DateFormat('hh:mm:ss');
    DateTime x = format.parse(dateTimeValue);
    dateTimeValue = DateFormat.jm().format(x);
    return dateTimeValue;
  }

  /// Format Time of String to TimeOfDay.Now();
  static formatTimeToTimeOfDay(String timeVal) {
    if (timeVal + '' == '') {
      return TimeOfDay.now();
    }
    var format = DateFormat.jm();
    var retVal = TimeOfDay.fromDateTime(format.parse(timeVal));
    return retVal;
  }

  Future<String> formatTimeTo24HFromServer(String pVal) async {
    if (pVal == "") {
      return pVal = "00:00";
    } else if (pVal.length == 5 || pVal.length == 8) {
      return pVal;
    }
    pVal = DateFormat("HH:mm").format(DateFormat.jm().parse(pVal));
    return pVal + ":00";
  }

  //Format Style for Dropdown Search
  static dropdownSearchDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        // gapPadding: 10.0,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
    );
  }

  static searchBoxDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
    );
  }

//
  static textFormFieldDecoration(
    String labelText, {
    Icon icon,
  }) {
    return InputDecoration(
      labelText: labelText,
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
      ),
      prefix: icon,
    );
  }

  static Widget suffixIcon(TextEditingController cnt) {
    var _visible = true;
    return IconButton(
      icon: Icon(_visible ? Icons.visibility : Icons.visibility_off),
      onPressed: () {
        _visible = false;
      },
    );
  }

  static textBox(
    TextEditingController cnt,
    String labelText, {
    bool readOnly = false,
    bool validate = false,
    GestureTapCallback onTap,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: cnt,
      readOnly: readOnly,
      obscureText: obscureText,
      decoration: AppUtilities.textFormFieldDecoration(labelText),
      onTap: onTap,
      validator: (value) {
        if (validate) {
          if (value == null || value.isEmpty) {
            return '$labelText is required!';
          } else {
            return null;
          }
        }
        return null;
      },
      autovalidateMode: validate ? AutovalidateMode.onUserInteraction : null,
    );
  }

  static borderRadius() {
    return BorderRadius.circular(7);
  }

  ///Custom Button
  ///
  ///
  static raisedButton(
    String text, {
    Color color = Colors.blue,
    VoidCallback onPressed,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: onPressed == null ? () {} : onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: AppUtilities.borderRadius(),
        ),
        padding: EdgeInsets.all(12),
        color: color,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  ///Customer DropDown
  ///
  static dropdownSearch(
    String label, {
    String selectedItem,
    List items,
    bool showSearchBox = false,
    bool showClearButton = true,
    Mode mode = Mode.DIALOG,
    bool validate = false,
    ValueChanged onChanged,
  }) {
    return DropdownSearch(
      selectedItem: selectedItem == null ? null : selectedItem,
      maxHeight: 350.0,
      hint: 'select $label',
      label: label,
      showSearchBox: showSearchBox,
      showClearButton: showClearButton,
      mode: mode,
      items: items == null ? [] : items,
      onChanged: onChanged.toString() == null ? (value) => {} : onChanged,
      validator: (value) {
        if (validate) {
          if (value == null) {
            return 'Please select $label';
          } else {
            return null;
          }
        } else {
          return null;
        }
      },
      autoValidateMode: validate ? AutovalidateMode.onUserInteraction : null,
      searchBoxDecoration: AppUtilities.searchBoxDecoration(),
      dropdownSearchDecoration: AppUtilities.dropdownSearchDecoration(),
    );
  }

  /// Custom Funtion for Get Value From List
  ///
  /// Get Code => code == true && name == false
  ///
  /// Get Name => code == false && name == true
  static String getValueFromLst(lst, bool pcode, bool pname, value) {
    if (lst == null || value == null || value == '') {
      return null;
    }

    if (pcode == true && pname == false) {
      return lst.where((element) => element.name == value).first.code;
    } else if (pcode == false && pname == true) {
      return lst.where((element) => element.code == value).first.name;
    } else {
      return null;
    }
  }

  static textFormFieldDecorationPrefixIcon(
      {String labelText, Icon prefixIcon}) {
    return InputDecoration(
      labelText: labelText,
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
      ),
      prefixIcon: prefixIcon,
    );
  }

  static snackBar(BuildContext context, String msg) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          // textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static snackBarButton(BuildContext context, String msg, String lable,
      {VoidCallback onPressed}) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          // textAlign: TextAlign.center,
        ),
        action: SnackBarAction(
          label: lable,
          onPressed: onPressed == null ? () {} : onPressed,
        ),
      ),
    );
  }
}
