import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lafyamind_app/src/constants/app_spacing.dart';
import 'package:lafyamind_app/src/exceptions/error_logger.dart';
import 'package:lafyamind_app/src/localization/string_hardcoded.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/app.dart';
import 'src/exceptions/async_error_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer(
    overrides: [],
    observers: [AsyncErrorLogger()],
  );
  final errorLogger = container.read(errorLoggerProvider);
  registerErrorHandlers(errorLogger);
  //await dotenv.load(fileName: ".env");
  //initSupabase();
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

void initSupabase() async {
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!);
}

void registerErrorHandlers(ErrorLogger errorLogger) {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    errorLogger.logError(details.exception, details.stack);
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    errorLogger.logError(error, stack);
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text('An error occurred'.hardcoded),
        ),
        body: Builder(builder: (ctx) {
          return Center(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  )),
              height: MediaQuery.of(ctx).size.height / 2,
              margin: screenPadding,
              padding: screenPadding,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    details.toString(),
                    maxLines: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                          onPressed: () {},
                          child: Text("Click to report the error ")),
                      ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: ctx,
                                builder: (ctx) {
                                  return const Column(
                                    children: [
                                      Text("Leaving the app..."),
                                      CircularProgressIndicator(),
                                    ],
                                  );
                                });
                            Future.delayed(
                                const Duration(seconds: 3), () => exit(0));
                          },
                          child: const Text("Restart the App"))
                    ],
                  )
                ],
              )),
            ),
          );
        }));
  };
}
