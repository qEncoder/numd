//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

<<<<<<< HEAD

void fl_register_plugins(FlPluginRegistry* registry) {
=======
#include <numd_c_libs/numd_c_libs_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) numd_c_libs_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "NumdCLibsPlugin");
  numd_c_libs_plugin_register_with_registrar(numd_c_libs_registrar);
>>>>>>> bef3b889d636b5a8648f8035a48536d95db7d647
}
