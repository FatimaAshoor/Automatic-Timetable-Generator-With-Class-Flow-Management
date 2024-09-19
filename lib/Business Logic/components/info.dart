import 'package:http/http.dart' as http;
import 'dart:convert';

var serverLink = 'http://127.0.0.1:8000/API';

class Info {
  getRequest(String url) async{
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200)
      {
        var responseBody = jsonDecode(response.body);
        return responseBody ;
      }
      else
      {
        print("Error ${response.statusCode}");
        return 'failed';
      }
    }
    catch (e)
    {
      print("Error Catch  $e ");
    }
  }

  postRequest(String url , dynamic data ) async {
    var response = await http.post(Uri.parse(url), body: data);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    }
    else
    {
      print("Error ${response.statusCode}");
    }
  }

  Login(String url , dynamic data ) async {
    var response = await http.post(Uri.parse(url), body: data);
    if (response.statusCode == 201 || response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      return responseBody ;
    }
    else if(response.statusCode == 406){
      return 'not_acceptable';
    }
    else if(response.statusCode == 404){
      return 'not_found';
    }
    else
    {
      print("Error ${response.statusCode}");
      return 'failed';
    }
  }

  postNestedRequest(String url , dynamic data ) async {
    final headers={'Content-Type': 'application/json'};
    var Data=jsonEncode(data);
    var response = await http.post(Uri.parse(url),headers: headers, body: Data);
    if (response.statusCode == 201) {
      return true;
    }
       else {
      print("Error ${response.statusCode}");
    }
  }

  putRequest(String url , Map<String,dynamic> data ) async {
    var response = await http.put(Uri.parse(url), body: data);
    if (response.statusCode == 200) {
      return true ;
    } else {
      print("Error ${response.statusCode}");
    }
  }
  putLecture(String url , Map<String,dynamic> data ) async {
    var response = await http.put(Uri.parse(url), body: data);
    if (response.statusCode == 200) {
      return true ;
    } else {
      return jsonDecode(response.body);

    }
  }

  putNestedRequest(String url , Map<String,Map> data ) async {
    final headers={'Content-Type': 'application/json'};
    var Data=jsonEncode( data);
    var response = await http.put(Uri.parse(url), headers: headers, body: Data);
    if (response.statusCode == 200) {
        return true ;
    } else {
      print("Error  ${response.statusCode}");
    }
  }

  deleteRequest(String url)async {
   var response = await http.delete(Uri.parse(url));
   if (response.statusCode == 200) {
     return true;
   }
   else {
     print("Error ${response.statusCode}");
   }
 }

 }

