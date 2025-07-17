// import "package:Yomcoin/screens/mainPage.dart";
import 'package:farm_to_dish/global_widgets.dart';
import 'package:go_router/go_router.dart';
import "package:flutter/material.dart";

import 'Remote/diotest.dart';
import 'Screens/Chat/chatScreen.dart';
import 'Screens/OTP/enter_otp.dart';
import 'Screens/Schedule/schedule_screen.dart';
import 'Screens/onboarding.dart';
import 'Screens/screens.dart';
import 'Screens/splash_screen.dart';
import 'global_objects.dart';
import 'global_string.dart';
// import "screens/screens.dart";
// import "models/global_objects.dart";

bool allowedToPop = false;

final GoRouter myRouter = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: isLoggedIn ? '/MyHomePage' : "/",
    // initialLocation: "/HomeScreen",
    routes: [
      // specialScreens
      GoRoute(
        path: "/error",
        name: "error",
        pageBuilder: (context, state) => DialogPage(
          builder: (context) => const ErrorPage(),
        ),
      ),
      GoRoute(
        path: "/success",
        name: "success",
        pageBuilder: (context, state) => DialogPage(
          builder: (context) => const SuccessPage(),
        ),
      ),
      GoRoute(
        path: "/loading",
        name: "loading",
        pageBuilder: (context, state) => DialogPage(
          builder: (context) => const LoadingPage(),
        ),
      ),
      GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
          routes: [
            GoRoute(
              path: 'otpPage',
              name: 'otpPage',
              builder: (BuildContext context, GoRouterState state) {
                /*
                return otp(
                  value: otp_['code']!.toString(),
                  recipient: otp_["Email"],
                  essence: "", // essence,
                  user: ussr_,
                );

                */

                return OTPPage(
                    // neededMapStringformat: (state.extra as String),
                    );
              },
            ),
            GoRoute(
              path: 'signUp',
              name: 'signUp',
              builder: (BuildContext context, GoRouterState state) {
                return const SignUpScreen(
                    // neededMapStringformat: (state.extra as String),
                    );
              },
            ),
            GoRoute(
              path: login,
              name: login,
              builder: (BuildContext context, GoRouterState state) {
                return const LoginScreen();
              },
            ),
            GoRoute(
              path: onboard,
              name: "onboard",
              builder: (BuildContext context, GoRouterState state) {
                return const LoginScreen();
              },
            )
          ]),
      // GoRoute(
      //   path: '/home',
      //   name: 'home',
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const HomeScreen();
      //   },
      // ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Return the widget that implements the custom shell (e.g a BottomNavigationBar).
          // The [StatefulNavigationShell] is passed to be able to navigate to other branches in a stateful way.
          return MainPage(navigationShell);
        },
        branches: [
          StatefulShellBranch(
            // navigatorKey: sectionNavigatorKey,
            // Add this branch routes
            // each routes with its sub routes if available e.g feed/uuid/details
            routes: <RouteBase>[
              // wrong
              GoRoute(
                path: '/ProfileScreen',
                name: 'ProfileScreen',
                builder: (context, state) => const ProfileScreen(),
              )
            ],
          ),
          StatefulShellBranch(
              navigatorKey: sectionNavigatorKey,
              // Add this branch routes
              // each routes with its sub routes if available e.g feed/uuid/details
              routes: <RouteBase>[
                GoRoute(
                  path: home,
                  name: 'HomeScreen',
                  builder: (context, state) => const HomeScreen(),
                )
              ]),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/ProductScreen',
                name: 'ProductScreen',
                builder: (context, state) =>
                    ProductScreen(initialySelectedTab: state.extra?.toString()),
                // RequestRoute(),
              )
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/DeliveryCarScreen',
                name: 'DeliveryCarScreen',
                builder: (context, state) => const DeliveryCarScreen(),
              )
            ],
          )
          // StatefulShellBranch(
          //   routes: <RouteBase>[
          //     GoRoute(
          //       path: '/Schedule',
          //       name: 'Schedule',
          //       builder: (context, state) => const Schedule(),
          //     )
          //   ],
          // ),
        ],
      ),
      // CartScreen
      GoRoute(
        path: '/CartScreen',
        name: 'CartScreen',
        builder: (BuildContext context, GoRouterState state) {
          return const CartScreen();
        },
      ),
      GoRoute(
        path: '/PaymentScreen',
        builder: (context, state) => PaymentScreen(amount: pay_[amt]),
      ),

      GoRoute(
        path: '/OTP',
        name: 'otpPaged',
        builder: (BuildContext context, GoRouterState state) {
          return otp(
            value: otp_['code']!.toString(),
            recipient: otp_["Email"],
            essence: otp_["Essence"], // essence,
            user: ussr_,
          );
          /*
                return OTPPage(
                    // neededMapStringformat: (state.extra as String),
                    );
                    */
        },
      ),
    ]
    //  <RouteBase>[
    //   GoRoute(
    //       path: '/',
    //       builder: (BuildContext context, GoRouterState state) {
    //         return const LoginScreen();
    //       },
    //       routes: [
    //         GoRoute(
    //           path: 'sign_up',
    //           builder: (BuildContext context, GoRouterState state) {
    //             return const SignUpScreen();
    //           },
    //         ),
    //         GoRoute(
    //           path: 'forgetPasswordPage',
    //           builder: (BuildContext context, GoRouterState state) {
    //             // state.extra
    //             return OTPPage(
    //               neededMapStringformat: (state.extra as String),
    //             );
    //           },
    //         ),
    //       ]),
    //   StatefulShellRoute.indexedStack(
    //     builder: (context, state, navigationShell) {
    //       // Return the widget that implements the custom shell (e.g a BottomNavigationBar).
    //       // The [StatefulNavigationShell] is passed to be able to navigate to other branches in a stateful way.
    //       return MainPage(navigationShell);
    //     },
    //     branches: [
    //       // The route branch for the 1º Tab
    //       StatefulShellBranch(
    //         navigatorKey: sectionNavigatorKey,
    //         // Add this branch routes
    //         // each routes with its sub routes if available e.g feed/uuid/details
    //         routes: <RouteBase>[
    //           GoRoute(
    //             path: '/MyHomePage',
    //             builder: (context, state) => const MyHomePage(),
    //             routes: [
    //               GoRoute(
    //                 path: 'add_money_coin_screen',
    //                 name: "add_money_coin_screen",
    //                 builder: (context, state) => const AddFundScreen(),
    //               ),
    //               GoRoute(
    //                 path: 'GiftCardScreen',
    //                 name: 'GiftCardScreen',
    //                 builder: (context, state) => const GiftCardScreen(),
    //                 routes: [
    //                   GoRoute(
    //                     path: 'GiftcardWebView',
    //                     name: "GiftcardWebView",
    //                     builder: (context, state) =>
    //                         GiftcardWebView(url: (state.extra as String)),
    //                   ),
    //                   GoRoute(
    //                       path: 'GiftCardFullDisplay',
    //                       name: "GiftCardFullDisplay",
    //                       builder: (context, state) => GiftCardFullDisplay(
    //                           detail: (state.extra as Map)["detail"],
    //                           name: (state.extra as Map)["name"])
    //                       // (url: (state.extra as String)),
    //                       ),

    //                   // GiftCardFullDisplay
    //                 ],
    //               ),
    //               GoRoute(
    //                 path: 'TransactionHistoryScreen',
    //                 name: "TransactionHistoryScreen",
    //                 builder: (context, state) => const TransactionHistoryScreen(),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),

    //       // The route branch for 2º Tab
    //       StatefulShellBranch(routes: <RouteBase>[
    //         // Add this branch routes
    //         // each routes with its sub routes if available e.g shope/uuid/details
    // GoRoute(
    //   path: '/BillsPaymentScreen',
    //   builder: (context, state) => const BillsPaymentScreen(),
    // ),
    //       ]),

    //       StatefulShellBranch(routes: <RouteBase>[
    //         // Add this branch routes
    //         // each routes with its sub routes if available e.g shope/uuid/details
    //         GoRoute(
    //             path: '/ProfileScreen',
    //             builder: (context, state) => const ProfileScreen(),
    //             routes: [
    //               GoRoute(
    //                 path: 'OptionsScreen',
    //                 name: "OptionsScreen",
    //                 builder: (context, state) => const OptionsScreen(),

    //                 // OptionsScreen
    //               ),
    //             ]
    //             // OptionsScreen
    //             ),
    //       ])
    //     ],
    //   ),
    // ],
    );

// GiftcardWebView GiftCardScreen