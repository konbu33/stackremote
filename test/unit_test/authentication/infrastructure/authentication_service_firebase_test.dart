import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/authentication/authentication.dart';

// class MockAuthenticationService extends Mock implements AuthenticationService {}
// final AuthenticationService authenticationService = MockAuthenticationService();

void main() {
  const String email = "xxx@test.com";
  const String password = "xxx";

  late AuthenticationService authenticationService;

  setUp(() {
    //
    const uid = "1";
    final mockUser = MockUser(
      uid: uid,
      email: email,
    );

    final MockFirebaseAuth mockFirebaseAuth =
        MockFirebaseAuth(mockUser: mockUser, signedIn: false);
    //
    final container = ProviderContainer(overrides: [
      //
      firebaseAuthInstanceProvider.overrideWithValue(mockFirebaseAuth),
    ]);

    authenticationService =
        container.read(authenticationServiceFirebaseProvider);
  });

  group('AuthenticationService', () {
    //
    test(
      'authStateChanges -> SignUp -> SignOut',
      () async {
        // given
        final authStateChanges = authenticationService.authStateChanges();

        // StreamControllerでラップしてみたパターン
        // このパターンの場合、複数箇所でlistenする場合？broadcastする必要がある様子。
        final streamController = StreamController<FirebaseAuthUser>();
        streamController.addStream(authStateChanges);

        final authStateChangesBroadcast =
            streamController.stream.asBroadcastStream();

        authStateChangesBroadcast.listen((event) {
          // print("listen event : $event");
        });

        // then
        expect(
          authStateChangesBroadcast,
          emitsInOrder(
            [
              equals(null),
              allOf(
                isA<MockUser>(),
                predicate<MockUser>(
                  (mockUser) {
                    expect(mockUser.email, equals(email));
                    return true;
                    //
                  },
                ),
              ),
              equals(null),
            ],
          ),
        );

        // when
        await authenticationService.signUp(email, password);
        await authenticationService.signOut();
      },
    );

    test(
      'authStateChanges -> SignIn -> SignOut',
      () async {
        // given
        final authStateChanges = authenticationService.authStateChanges();

        authStateChanges.listen((event) {
          // print("listen event : $event");
        });

        // then
        expect(
          authStateChanges,
          emitsInOrder(
            [
              equals(null),
              allOf(
                isA<MockUser>(),
                predicate<MockUser>(
                  (mockUser) {
                    expect(mockUser.email, equals(email));
                    return true;
                    //
                  },
                ),
              ),
              equals(null),
            ],
          ),
        );

        // when
        await authenticationService.signIn(email, password);
        await authenticationService.signOut();
      },
    );

    test(
      'SignUp -> Error: email-already-in-use',
      () async {
        // given
        const String code = "email-already-in-use";

        final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth(
          authExceptions: AuthExceptions(
            createUserWithEmailAndPassword: FirebaseAuthException(code: code),
          ),
        );

        final container = ProviderContainer(overrides: [
          //
          firebaseAuthInstanceProvider.overrideWithValue(mockFirebaseAuth),
        ]);

        //
        authenticationService =
            container.read(authenticationServiceFirebaseProvider);

        // when
        // then
        expect(
          () async => await authenticationService.signUp(email, password),
          allOf(
            throwsA(isA<FirebaseAuthException>()),
            throwsA(
              predicate<FirebaseAuthException>(
                (firebaseAuthException) {
                  expect(firebaseAuthException.code, equals(code));
                  return true;
                  //
                },
              ),
            ),
          ),
        );
      },
    );

    test(
      'SignIn -> Error: user-not-found, too-many-requests',
      () async {
        // given
        // const String code = "user-not-found";
        // const String code = "too-many-requests";
        const List<String> codeList = [
          "user-not-found",
          "too-many-requests",
        ];

        for (final code in codeList) {
          final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth(
            authExceptions: AuthExceptions(
              signInWithEmailAndPassword: FirebaseAuthException(code: code),
            ),
          );

          final container = ProviderContainer(overrides: [
            //
            firebaseAuthInstanceProvider.overrideWithValue(mockFirebaseAuth),
          ]);

          //
          authenticationService =
              container.read(authenticationServiceFirebaseProvider);

          // when
          // then
          expect(
            () async => await authenticationService.signIn(email, password),
            allOf(
              throwsA(isA<FirebaseAuthException>()),
              throwsA(
                predicate<FirebaseAuthException>(
                  (firebaseAuthException) {
                    expect(firebaseAuthException.code, equals(code));
                    return true;
                    //
                  },
                ),
              ),
            ),
          );
        }
      },
    );

    //
  });
}
