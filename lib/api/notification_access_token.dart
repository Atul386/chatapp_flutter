import 'dart:developer';

import 'package:googleapis_auth/auth_io.dart';

class NotificationAccessToken {
  static String? _token;

  //to generate token only once for an app run
  static Future<String?> get getToken async => _token ?? await _getAccessToken();

  // to get admin bearer token
  static Future<String?> _getAccessToken() async {
    try {
      const fMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      final client = await clientViaServiceAccount(
        // To get Admin Json File: Go to Firebase > Project Settings > Service Accounts
        // > Click on 'Generate new private key' Btn & Json file will be downloaded

        // Paste Your Generated Json File Content
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "chatapp-flutter-46db3",
          "private_key_id": "a1999e0a112c61b7e6b273f1d20660067ea22601",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDkEQ78O10q23NN\nmJgOhi3xfRTRWKmLkFfACEnUEFa08kZUvuYiE9xNAnoFCotMfUV33j7Ye1puoZp+\nUGEbb3L2pIbwtXpTN6XwXf56VHL2TaqDlknBCI+W9KgN8pjkSH6JNLLWajqEFUe2\nDdoyZrNZuN6jj4de6dOfn4ju1FakMXHktWztXw6QA2dVTNzhiG7TF7pJeFVyPhL5\nlKDbwhghF9Pg09rc+aJvXdL8BZOY0NTXzIE5pouwtsSjacR5sfRShfGzoHi9GLgo\nEY8oqvPwO8I/JXYX0hZ+3vt0jWvcHUpQUEeLDXrc+ckTegxngdllBsitpE5dBLFR\nhpfai/3HAgMBAAECggEACQfP4xbqqn7EAweOxcx0V0KPp3ZuSDNv9g+d9MKs3D9X\nn5VrgV/t8jKt6DMxrtarAIMRU/sWapkFiAjgv3hbQf7jxPY6oL7sWCcwo2Fip/QN\nU2aJBxaysNSBLwQzH57rO72Vcz4DkSVSkJfd0u8UHPJgBnPxdUWm9oQXpPVNdPTZ\nF5yxNLetQDACOW8DCLXdTWUO2hD3kl3x7FshCd9l1s2roj0dQIIN7ghbj96l2JGq\nX0MtMleA4bc/4qnN2zpHt7L54/KeCsLKei2ZQuVvuFSfgNTfIUCZccrY4Ei1OOMf\nzKlIuLoa3S2rv1pwxH8nHJe1yLG/9mAEL6+emrPLuQKBgQD+RnBDnxoxfQTSt1O9\nuljq6Ax8agFx59WzQ2mGjfVMvT15vJMZXxYeJCJ360o4pwtAY9nXF5GyIZLAFH+Q\nPIvreurQht4krucC5UveaQ8bpnfJ7+iDoSsE/hgfXnbuwlHDGBfr6tM0YRuXzIJ2\nJ4QUZ2Q16//z1o1TEwDxb9aiRQKBgQDlnRuMaOqZzrPDIwfGS7JTWyzCQCkWtSvf\nPOu6zy/3qiQZofWiQa5mMlfn6rr9Gw5j7HITo4qeDQG5/IwKHJSHgzDS87BGs0ES\n+4ndSj5cgPny1r93buLIQ+FUuUxNZLxd5+jn6ClZAJmJ3RiGRlAVUWhU9fkg/882\nBhzaklOmmwKBgFC0iLNdz1F/zcUXvPOOLuS4LCZc+wJtRA22ysqTShVGRznZWZMG\n9B0y+OG5A4DBvDd+ucikSXERaOOgXfCo1vwxsk/nTqC0BsyLfK4mCE6NYp3skI8e\n22mlQIDMWdFkSdEzV3xgtxJ78+cVWR8pYamcO1lGA6IgKhEBCh6XkbdFAoGATlRT\nMooUBhZKorYPj+kA04jV8wpaOgHiDozEyfymG3HyUMA8gHaxnPFtpZMg6PlS5mmh\n3Os8fYBoZ18tEsH/NV9ex4gUSXobJ/Oha1lJftsM6Xey53ZvbOwjMXjo+7nyvIJB\npONBP7iBqFNBa4UPCsaztdAXhddeg8qAC1xBpyMCgYA4rEvDNmuEsMOfKeuaI/wf\n0tiklsPyArarP+v5isn9v4lxs0sggAd/zy5eaS+HUCIy0rIXb4SfUuQHKC55Eouz\naresbhZJlB60n9b9iIWvN63BLVLBGfhWyu9HvUTlCHPjAPQ2vGvAIxES/iSKqFin\nTaiVr8EU33CV8/7px/ij7g==\n-----END PRIVATE KEY-----\n",
          "client_email": "firebase-adminsdk-syyeg@chatapp-flutter-46db3.iam.gserviceaccount.com",
          "client_id": "117917405563800406030",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-syyeg%40chatapp-flutter-46db3.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }

        ),
        [fMessagingScope],
      );

      _token = client.credentials.accessToken.data;

      return _token;
    } catch (e) {
      log('$e');
      return null;
    }
  }
}
