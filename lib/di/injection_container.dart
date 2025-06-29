import 'package:get_it/get_it.dart';

import 'register_coreLayer.dart';
import 'register_date_layer.dart';
import 'register_domain_layer.dart';
import 'register_presentation_layer.dart';

final sl = GetIt.instance;

Future<void> init() async {
  registerCoreLayer();
  await registerDateLayer();
  registerDomainLayer();
  registerPresentationLayer();
}
