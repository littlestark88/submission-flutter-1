import 'package:core/common/constants.dart';
import 'package:core/common/ssl_pining.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SSL Piningg Http ', (){
    test(
        'Should get response 200 when success connect',
        () async {
          final _client = await Shared.createLEClient(isTestMode: true);
          final response = await _client.get(Uri.parse(
              '$BASE_URL/3/movie/now_playing?$API_KEY'));
          expect(response.statusCode, 200);
          _client.close();
        },
    );
  });
}