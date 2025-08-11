import 'package:cashier_system/core/class/statusrequest.dart';

StatusRequest handlingData(dynamic response) {
  if (response is StatusRequest) {
    return response;
  }

  if (response == null) {
    return StatusRequest.noData;
  }

  if (response is Map &&
      response.containsKey('status') &&
      response['status'] == 'failure') {
    return StatusRequest.failure;
  }

  return StatusRequest.success;
}
