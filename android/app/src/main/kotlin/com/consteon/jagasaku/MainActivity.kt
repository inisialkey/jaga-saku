package com.consteon.jagasaku

import io.flutter.embedding.android.FlutterFragmentActivity

// FlutterFragmentActivity (not FlutterActivity) is required by local_auth's
// BiometricPrompt (V3-M4 App Lock). Same android:name=".MainActivity", so the
// LaunchTheme / singleTop / deep-link intent-filters in AndroidManifest.xml are
// unaffected.
class MainActivity : FlutterFragmentActivity()
