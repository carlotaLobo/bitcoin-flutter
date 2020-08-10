
import 'package:http/http.dart' as http;
import 'dart:convert'; // para utilizar JSON

const String apiKey = 'D451AFFB-3E84-4825-A551-8CE96F1E6546';
const String url = 'https://rest.coinapi.io/v1/exchangerate';

class ConnectionApi {
  final coin;
  final crypto;

  ConnectionApi({this.coin, this.crypto});

  Future getData() async {
    http.Response response =
        await http.get('$url/$crypto/$coin?apikey=$apiKey');
        print('$url/$crypto/$coin?apikey=$apiKey');

    if (response.statusCode == 200) {

      return await jsonDecode(response.body);
    } else {
      print(response.headers);
    }
  }
}
