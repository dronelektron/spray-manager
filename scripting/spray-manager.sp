#include <sourcemod>
#include <sdktools>
#undef REQUIRE_PLUGIN
#include <adminmenu>

#include "sm/math"
#include "sm/menu"
#include "sm/message"
#include "sm/sound"
#include "sm/temp-entity"
#include "sm/use-case"

#include "modules/client.sp"
#include "modules/console-command.sp"
#include "modules/entity.sp"
#include "modules/menu.sp"
#include "modules/message.sp"
#include "modules/sound.sp"
#include "modules/temp-entity.sp"
#include "modules/use-case.sp"

public Plugin myinfo = {
    name = "Spray manager",
    author = "Dron-elektron",
    description = "Allows you to perform various actions with sprays",
    version = "0.2.0",
    url = "https://github.com/dronelektron/spray-manager"
};

public void OnPluginStart() {
    AdminMenu_Create();
    Command_Create();
    TempEntity_HookSpray();
    Sound_Precache();
    LoadTranslations("common.phrases");
    LoadTranslations("spray-manager.phrases");
}

public void OnPluginEnd() {
    TempEntity_UnhookSpray();
}

public void OnAdminMenuReady(Handle topMenu) {
    AdminMenu_OnReady(topMenu);
}

public void OnLibraryRemoved(const char[] name) {
    if (strcmp(name, ADMIN_MENU) == 0) {
        AdminMenu_Destroy();
    }
}

public void OnClientConnected(int client) {
    Client_UnmarkSprayOwner(client);
}

public void OnClientDisconnect(int client) {
    Client_UnmarkSprayOwner(client);
}
