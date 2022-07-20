// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import '../../utils/kkiapayConf.sample.dart';
import '../view/widget_builder_view.dart';

class Routes {
  static const String kKiaPay = '/k-kia-pay';
  static const all = <String>{
    kKiaPay,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.kKiaPay, page: KKiaPay),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    KKiaPay: (data) {
      var args = data.getArgs<KKiaPayArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => KKiaPay(
          key: args.key,
          amount: args.amount,
          phone: args.phone,
          data: args.data,
          paymentMethod: args.paymentMethod,
          sandbox: args.sandbox,
          apikey: args.apikey,
          callback: args.callback,
          theme: args.theme,
          name: args.name,
          email: args.email,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// KKiaPay arguments holder class
class KKiaPayArguments {
  final Key? key;
  final int amount;
  final String? phone;
  final String? data;
  final PaymentMethod? paymentMethod;
  final bool? sandbox;
  final String? apikey;
  final dynamic Function(Map<String, dynamic>, BuildContext) callback;
  final String? theme;
  final String? name;
  final String? email;
  KKiaPayArguments(
      {this.key,
      required this.amount,
      this.phone,
      this.data,
      this.paymentMethod,
      this.sandbox,
      required this.apikey,
      required this.callback,
      this.theme,
      this.name,
      this.email});
}
