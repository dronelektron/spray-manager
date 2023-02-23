#include <sourcemod>
#include <sdktools>
#undef REQUIRE_PLUGIN
#include <adminmenu>

#include "sm/math"
#include "sm/menu"
#include "sm/message"
#include "sm/sound"
#include "sm/spray-list"
#include "sm/temp-entity"
#include "sm/use-case"

#include "modules/console-command.sp"
#include "modules/entity.sp"
#include "modules/menu.sp"
#include "modules/message.sp"
#include "modules/sound.sp"
#include "modules/spray-list.sp"
#include "modules/temp-entity.sp"
#include "modules/use-case.sp"

public Plugin myinfo = {
    name = "Spray manager",
    author = "Dron-elektron",
    description = "Allows you to perform various actions with sprays",
    version = "1.0.0",
    url = "https://github.com/dronelektron/spray-manager"
};

public void OnPluginStart() {
    AdminMenu_Create();
    Command_Create();
    SprayList_Create();
    TempEntity_HookSpray();
    Sound_Precache();
    HookEvent("player_changename", Event_ChangePlayerName);
    LoadTranslations("common.phrases");
    LoadTranslations("spray-manager.phrases");
}

public void Event_ChangePlayerName(Event event, const char[] name, bool dontBroadcast) {
    int userId = event.GetInt("userid");
    int client = GetClientOfUserId(userId);
    char playerName[MAX_NAME_LENGTH];

    event.GetString("newname", playerName, sizeof(playerName));

    UseCase_SetClientNameForSpray(client, playerName);
}

public void OnPluginEnd() {
    SprayList_Destroy();
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

public void OnMapStart() {
    SprayList_Clear();
}

public void OnClientPostAdminCheck(int client) {
    char name[MAX_NAME_LENGTH];

    UseCase_GetName(client, name);
    UseCase_SetClientForSpray(client);
    UseCase_SetClientNameForSpray(client, name);
}

public void OnClientDisconnect(int client) {
    UseCase_RemoveClientFromSpray(client);
}
