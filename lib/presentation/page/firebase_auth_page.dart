import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/domain/firebase_auth_user.dart';

class FirebaseAuthPage extends StatelessWidget {
  const FirebaseAuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Auth Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Text("Firebase Auth Page : ${DateTime.now()}"),
            // const SizedBox(height: 30),
            const SizedBox(height: 10),
            FirebaseAuthPageWidgets.sendEmailVerifiedWidget(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FirebaseAuthPageWidgets.userAddWidget(),
                FirebaseAuthPageWidgets.userDelWidget(),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FirebaseAuthPageWidgets.userSignInWidget(),
                FirebaseAuthPageWidgets.userSignOutWidget(),
              ],
            ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FirebaseAuthPageWidgets.userGetCurrentUserWidget(),
                FirebaseAuthPageWidgets.userReloadWidget(),
              ],
            ),
            const SizedBox(height: 30),
            FirebaseAuthPageWidgets.userDysplayWidget(),
          ],
        ),
      ),
    );
  }
}

class FirebaseAuthPageWidgets {
  static Widget userAddWidget() {
    Widget widget = Consumer(
      builder: (context, ref, child) {
        final notifier =
            ref.read(firebaseAuthUserStateNotifierProvider.notifier);
        return ElevatedButton(
          onPressed: () async {
            const email = "konbu33@gmail.com";
            const password = "P@ssw0rd";
            final res = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: email, password: password);

            final updateFirebaseAuthUserState =
                ref.read(updateFirebaseAuthUserStateProvider);
            updateFirebaseAuthUserState(res.user);
          },
          child: const Text("user add"),
        );
      },
    );

    return widget;
  }

  static Widget userDelWidget() {
    Widget widget = Consumer(builder: (context, ref, child) {
      return ElevatedButton(
        onPressed: () async {
          await FirebaseAuth.instance.currentUser!.delete();
          final updateFirebaseAuthUserState =
              ref.read(updateFirebaseAuthUserStateProvider);
          updateFirebaseAuthUserState(null);
        },
        child: const Text("user del"),
      );
    });

    return widget;
  }

  static Widget sendEmailVerifiedWidget() {
    Widget widget = ElevatedButton(
      onPressed: () async {
        await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      },
      child: const Text("sendEmailVelified"),
    );

    return widget;
  }

  static Widget userGetCurrentUserWidget() {
    Widget widget = Consumer(builder: (context, ref, child) {
      return ElevatedButton(
        onPressed: () async {
          final user = FirebaseAuth.instance.currentUser;
          final updateFirebaseAuthUserState =
              ref.read(updateFirebaseAuthUserStateProvider);
          updateFirebaseAuthUserState(user);
        },
        child: const Text("user Get Current User"),
      );
    });

    return widget;
  }

  static Widget userReloadWidget() {
    Widget widget = Consumer(builder: (context, ref, child) {
      return ElevatedButton(
        onPressed: () async {
          final res = FirebaseAuth.instance.currentUser!.reload();
          // final updateFirebaseAuthUserState =
          //     ref.read(updateFirebaseAuthUserStateProvider);
          // updateFirebaseAuthUserState(res);
        },
        child: const Text("user reload"),
      );
    });

    return widget;
  }

  static Widget userSignInWidget() {
    Widget widget = Consumer(
      builder: (context, ref, child) {
        // final notifier =
        //     ref.read(firebaseAuthUserStateNotifierProvider.notifier);
        return ElevatedButton(
          onPressed: () async {
            const email = "konbu33@gmail.com";
            const password = "P@ssw0rd";
            final res = await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: email, password: password);

            final updateFirebaseAuthUserState =
                ref.read(updateFirebaseAuthUserStateProvider);
            updateFirebaseAuthUserState(res.user);
          },
          child: const Text("user SignIn"),
        );
      },
    );

    return widget;
  }

  static Widget userSignOutWidget() {
    Widget widget = Consumer(builder: (context, ref, child) {
      return ElevatedButton(
        onPressed: () async {
          final res = FirebaseAuth.instance.signOut();
          final updateFirebaseAuthUserState =
              ref.read(updateFirebaseAuthUserStateProvider);
          updateFirebaseAuthUserState(null);
        },
        child: const Text("user SignOut"),
      );
    });

    return widget;
  }

  static Widget userDysplayWidget() {
    Widget widget = Consumer(builder: (context, ref, child) {
      final state = ref.watch(firebaseAuthUserStateNotifierProvider);
      // final User? currentUser = FirebaseAuth.instance.currentUser;

      return Column(
        children: [
          Text("DateTime.now(): ${DateTime.now()}"),
          const Divider(),
          StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              return Text(
                  "authStateChanges: ${DateTime.now()} ${snapshot.data}");
            },
          ),
          //
          //
          const SizedBox(height: 30),
          const Divider(),
          StreamBuilder(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, snapshot) {
              return Text("userChanges: ${DateTime.now()} ${snapshot.data}");
            },
          ),
          //
          //
          const SizedBox(height: 30),
          const Divider(),
          Text("firebaseAuthUser : ${DateTime.now()} ${state}"),
          //
          //
          const SizedBox(height: 30),
          const Divider(),
        ],
      );
    });
    return widget;
  }
}

final updateFirebaseAuthUserStateProvider = Provider((ref) {
  final notifier = ref.read(firebaseAuthUserStateNotifierProvider.notifier);

  late FirebaseAuthUser firebaseAuthUser;

  void updateFirebaseAuthUserState(User? user) async {
    if (user == null) {
      print("updateFirebaseAuthUserState : user is null");

      // final FirebaseAuthUser firebaseAuthUser = FirebaseAuthUser.create(
      firebaseAuthUser = FirebaseAuthUser.create(
        email: "null",
        emailVerified: false,
        password: "null",
        firebaseAuthUid: "null",
        firebaseAuthIdToken: "null",
      );
    } else {
      print("updateFirebaseAuthUserState resu.user : ${user}");
      print("updateFirebaseAuthUserState resu.user : ${user.uid}");

      // final FirebaseAuthUser firebaseAuthUser = FirebaseAuthUser.create(
      firebaseAuthUser = FirebaseAuthUser.create(
        email: user.email!,
        emailVerified: user.emailVerified,
        password: "init password",
        firebaseAuthUid: user.uid,
        firebaseAuthIdToken: (await user.getIdToken()).substring(0, 10),
      );
    }

    notifier.userInformationRegiser(firebaseAuthUser);
  }

  return updateFirebaseAuthUserState;
});
