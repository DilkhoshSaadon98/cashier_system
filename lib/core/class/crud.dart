import 'dart:convert';
import 'dart:io';
import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/functions/check_internet.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

String _basicAuth =
    'Basic ${base64Encode(utf8.encode('dddd:sdfsdfsdfsdfdsf'))}';
Map<String, String> _myheaders = {'authorization': _basicAuth};

class Crud {
  //! Post without image
  Future<Either<StatusRequest, Map>> postData(String linkurl, Map data) async {
    if (await checkInternet()) {
      var response = await http.post(Uri.parse(linkurl), body: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = jsonDecode(response.body);

        return Right(responsebody);
      } else {
        return const Left(StatusRequest.serverfailure);
      }
    } else {
      return const Left(StatusRequest.offlinefailure);
    }
  }

  Future<Either<StatusRequest, Map>> postDataWithList(
      String linkurl, String cartNumber, List<String> listData) async {
    var data = {
      "cart_number": cartNumber,
      "items_id": listData,
    };

    // Encode the data map to JSON format
    String jsonData = jsonEncode(data);
    // Send the request with the JSON-encoded data
    var response = await http.post(Uri.parse(linkurl), body: jsonData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map responseBody = jsonDecode(response.body);

      return Right(responseBody);
    } else {
      return const Left(StatusRequest.serverfailure);
    }
  }

  //! post with one image:
  Future<Either<StatusRequest, Map>> addRequestWithOneImage(
      url, data, File? image,
      [String? nameRequest]) async {
    nameRequest ??= 'files';
    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(_myheaders);
    if (image != null) {
      var length = await image.length();
      var stream = http.ByteStream(image.openRead());
      stream.cast();
      var multipleFile = http.MultipartFile(nameRequest, stream, length,
          filename: basename(image.path));
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
      return const Left(StatusRequest.serverfailure);
    }
  }
}
