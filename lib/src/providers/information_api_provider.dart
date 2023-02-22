import 'package:api_to_sqlite/src/models/information_model.dart';
import 'package:api_to_sqlite/src/providers/db_provider.dart';
import 'package:dio/dio.dart';

class InformationApiProvider {
  Future<List<Information?>> getAllInformation() async {
    var url = "https://63c188f6376b9b2e647e4892.mockapi.io/I05/info";
    Response response = await Dio().get(url);

    return (response.data as List).map((information) {
      // ignore: avoid_print
      print('Inserting $information');
      DBProvider.db.createInformation(Information.fromJson(information));
    }).toList();
  }
}
