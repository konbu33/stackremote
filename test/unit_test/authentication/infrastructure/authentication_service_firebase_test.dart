import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:stackremote/authentication/authentication.dart';
import 'package:stackremote/common/common.dart';

void main() {
  const String email = "xxx@test.com";
  const String password = "xxx";
  const uid = "1";

  late AuthenticationService authenticationService;

  setUp(() {
    //
    final mockUser = MockUser(
      email: email,
      isEmailVerified: false,
      uid: uid,
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
              // equals(null),
              // equals(isA<FirebaseAuthUser>()),
              allOf(
                isA<FirebaseAuthUser>(),
                predicate<FirebaseAuthUser>(
                  (firebaseAuthUser) {
                    expect(firebaseAuthUser.email, equals(""));
                    expect(firebaseAuthUser.emailVerified, isFalse);
                    expect(firebaseAuthUser.firebaseAuthUid, equals(""));
                    expect(firebaseAuthUser.isSignIn, isFalse);
                    return true;
                    //
                  },
                ),
              ),

              allOf(
                isA<FirebaseAuthUser>(),
                predicate<FirebaseAuthUser>(
                  (firebaseAuthUser) {
                    expect(firebaseAuthUser.email, equals(email));
                    expect(firebaseAuthUser.emailVerified, isTrue);
                    expect(
                        firebaseAuthUser.firebaseAuthUid, equals("mock_uid"));
                    expect(firebaseAuthUser.isSignIn, isTrue);
                    return true;
                    //
                  },
                ),
              ),

              allOf(
                isA<FirebaseAuthUser>(),
                predicate<FirebaseAuthUser>(
                  (firebaseAuthUser) {
                    expect(firebaseAuthUser.email, equals(""));
                    expect(firebaseAuthUser.emailVerified, isFalse);
                    expect(firebaseAuthUser.firebaseAuthUid, equals(""));
                    expect(firebaseAuthUser.isSignIn, isFalse);
                    return true;
                    //
                  },
                ),
              ),

              // equals(isA<FirebaseAuthUser>()),
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
              // equals(null),

              allOf(
                isA<FirebaseAuthUser>(),
                predicate<FirebaseAuthUser>(
                  (firebaseAuthUser) {
                    expect(firebaseAuthUser.email, equals(""));
                    expect(firebaseAuthUser.emailVerified, isFalse);
                    expect(firebaseAuthUser.firebaseAuthUid, equals(""));
                    expect(firebaseAuthUser.isSignIn, isFalse);
                    return true;
                    //
                  },
                ),
              ),
              allOf(
                isA<FirebaseAuthUser>(),
                predicate<FirebaseAuthUser>(
                  (firebaseAuthUser) {
                    expect(firebaseAuthUser.email, equals(email));
                    expect(firebaseAuthUser.emailVerified, isFalse);
                    expect(firebaseAuthUser.firebaseAuthUid, equals(uid));
                    expect(firebaseAuthUser.isSignIn, isTrue);
                    return true;
                    //
                  },
                ),
              ),
              allOf(
                isA<FirebaseAuthUser>(),
                predicate<FirebaseAuthUser>(
                  (firebaseAuthUser) {
                    expect(firebaseAuthUser.email, equals(""));
                    expect(firebaseAuthUser.emailVerified, isFalse);
                    expect(firebaseAuthUser.firebaseAuthUid, equals(""));
                    expect(firebaseAuthUser.isSignIn, isFalse);
                    return true;
                    //
                  },
                ),
              ),

              // equals(null),
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
            throwsA(isA<StackremoteException>()),
            throwsA(
              predicate<StackremoteException>(
                (stackremoteException) {
                  expect(stackremoteException.code, equals(code));
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
              throwsA(isA<StackremoteException>()),
              throwsA(
                predicate<StackremoteException>(
                  (stackremoteException) {
                    expect(stackremoteException.code, equals(code));
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
