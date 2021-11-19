import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void access(List<String> arguments) async {
  var url = Uri.https('www.googleapis.com', '/books/v1/volumes', {'q': '{http}'});

  // Await the http get response, then decode the json-formatted response.
  var response = await http.get(url);
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print(response.statusCode);
  }
}