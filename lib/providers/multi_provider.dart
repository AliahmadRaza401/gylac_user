import 'package:gyalcuser_project/providers/create_delivery_provider.dart';
import 'package:gyalcuser_project/providers/loading_provider.dart';
import 'package:gyalcuser_project/providers/userProvider.dart';

import 'package:provider/provider.dart';

var multiProvider = [
  ChangeNotifierProvider<CreateDeliveryProvider>(
    create: (_) => CreateDeliveryProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<LoadingProvider>(
    create: (_) => LoadingProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<UserProvider>(
    create: (_) => UserProvider(),
    lazy: true,
  ),


];
