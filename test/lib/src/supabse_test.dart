import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: ".env");
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
  });

  test('Supabase should initialize correctly', () {
    final client = Supabase.instance.client;
    expect(client, isNotNull);
    expect(client.url, dotenv.env['SUPABASE_URL']);
  });

  test('Supabase query should return data', () async {
    final response = await Supabase.instance.client
        .from('your_table_name')
        .select()
        .execute();

    expect(response.error, isNull);
    expect(response.data, isNotEmpty); // Adjust based on your expected data
  });
}
