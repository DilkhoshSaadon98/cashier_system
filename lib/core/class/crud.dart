import 'dart:convert';
import 'dart:io';
import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/functions/check_internet.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

String _basicAuth =
    'Basic ${base64Encode(utf8.encode('dddd:sdfsdfsdfsdfdsf'))}';
Map<String, String> myHeaders = {'authorization': _basicAuth};

class Crud {
  //! Post without file
  Future<Either<StatusRequest, Map>> postData(String linkUrl, Map data) async {
    try {
      // Check for internet connection
      if (await checkInternet()) {
        // Perform the POST request
        var response = await http.post(
          Uri.parse(linkUrl),
          body: data,
          headers: myHeaders,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          Map<String, dynamic> responseBody = jsonDecode(response.body);
          return Right(responseBody);
        } else {
          showErrorDialog("", title: "Error", message: "Error in server");
          return const Left(StatusRequest.serverFailure);
        }
      } else {
        showErrorDialog("", title: "Error", message: "Internet fail");
        return const Left(StatusRequest.offlineFailure);
      }
    } catch (e) {
      showErrorDialog("$e", title: "Error", message: "Error in postData");
      return const Left(StatusRequest.failure);
    }
  }

  //! post with File:
  Future<Either<StatusRequest, Map>> addRequestWithOneFile(
      url, data, File? file,
      [String? nameRequest]) async {
    nameRequest ??= 'files';
    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(myHeaders);
    if (file != null) {
      var length = await file.length();
      var stream = http.ByteStream(file.openRead());
      stream.cast();
      var multipleFile = http.MultipartFile(nameRequest, stream, length,
          filename: basename(file.path));
      request.files.add(multipleFile);
    }

    //! Add Data To Request:
    data.forEach((key, value) {
      request.fields[key] = value;
    });
    //! Send Request:
    var myRequest = await request.send();
    //! Get Response Body:
    var respnose = await http.Response.fromStream(myRequest);
    if (respnose.statusCode == 200 || respnose.statusCode == 201) {
      Map responseBody = jsonDecode(respnose.body);
      return Right(responseBody);
    } else {
      return const Left(StatusRequest.serverFailure);
    }
  }
  
}
