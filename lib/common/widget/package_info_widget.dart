import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoWidget extends StatelessWidget {
  const PackageInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final packageInfo = ref.watch(packageInfoProvider);

        Widget buildAppVersionWidget({
          String? version,
          String? buildNumber,
        }) {
          final versionString =
              "バージョン：${version ?? "不明"}  /  ビルド：${buildNumber ?? "不明"}";

          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            color: Colors.grey.withOpacity(0.3),
            child: Text(versionString),
          );
        }

        return packageInfo.when(
          data: (data) {
            return buildAppVersionWidget(
              version: data.version,
              buildNumber: data.buildNumber,
            );
          },
          error: (error, stackTrace) {
            return buildAppVersionWidget();
          },
          loading: () {
            return const CircularProgressIndicator();
          },
        );
      },
    );
  }
}

// --------------------------------------------------
//
// packageInfoProvider
//
// --------------------------------------------------
final packageInfoProvider = FutureProvider((ref) {
  Future<PackageInfo> getPackageInfo() async {
    // Be sure to add this line if `PackageInfo.fromPlatform()` is called before runApp()
    // WidgetsFlutterBinding.ensureInitialized();

    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }

  return getPackageInfo();
});
