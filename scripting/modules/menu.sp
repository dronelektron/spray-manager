static TopMenu g_adminMenu = null;

static TopMenuObject g_sprayManagerCategory = INVALID_TOPMENUOBJECT;
static TopMenuObject g_menuItemTraceSpray = INVALID_TOPMENUOBJECT;
static TopMenuObject g_menuItemRemoveSpray = INVALID_TOPMENUOBJECT;
static TopMenuObject g_menuItemRemoveAllSprays = INVALID_TOPMENUOBJECT;
static TopMenuObject g_menuItemDrawSpray = INVALID_TOPMENUOBJECT;

void AdminMenu_Create() {
    TopMenu topMenu = GetAdminTopMenu();

    if (LibraryExists(ADMIN_MENU) && topMenu != null) {
        OnAdminMenuReady(topMenu);
    }
}

void AdminMenu_Destroy() {
    g_adminMenu = null;
}

public void AdminMenu_OnReady(Handle topMenuHandle) {
    TopMenu topMenu = TopMenu.FromHandle(topMenuHandle);

    if (topMenu == g_adminMenu) {
        return;
    }

    g_adminMenu = topMenu;

    AdminMenu_Fill();
}

void AdminMenu_Fill() {
    g_sprayManagerCategory = g_adminMenu.AddCategory(SPRAY_MANAGER, AdminMenuHandler_SprayManager);

    if (g_sprayManagerCategory != INVALID_TOPMENUOBJECT) {
        g_menuItemTraceSpray = AdminMenu_AddItem(ITEM_SPRAY_TRACE);
        g_menuItemRemoveSpray = AdminMenu_AddItem(ITEM_SPRAY_REMOVE);
        g_menuItemRemoveAllSprays = AdminMenu_AddItem(ITEM_SPRAY_REMOVE_ALL);
        g_menuItemDrawSpray = AdminMenu_AddItem(ITEM_SPRAY_DRAW);
    }
}

TopMenuObject AdminMenu_AddItem(const char[] name) {
    return g_adminMenu.AddItem(name, AdminMenuHandler_SprayManager, g_sprayManagerCategory);
}

public void AdminMenuHandler_SprayManager(TopMenu topMenu, TopMenuAction action, TopMenuObject topObjectId, int param, char[] buffer, int maxLength) {
    if (action == TopMenuAction_DisplayOption) {
        if (topObjectId == g_sprayManagerCategory) {
            Format(buffer, maxLength, "%T", SPRAY_MANAGER, param);
        } else if (topObjectId == g_menuItemTraceSpray) {
            Format(buffer, maxLength, "%T", ITEM_SPRAY_TRACE, param);
        } else if (topObjectId == g_menuItemRemoveSpray) {
            Format(buffer, maxLength, "%T", ITEM_SPRAY_REMOVE, param);
        } else if (topObjectId == g_menuItemRemoveAllSprays) {
            Format(buffer, maxLength, "%T", ITEM_SPRAY_REMOVE_ALL, param);
        } else if (topObjectId == g_menuItemDrawSpray) {
            Format(buffer, maxLength, "%T", ITEM_SPRAY_DRAW, param);
        }
    } else if (action == TopMenuAction_DisplayTitle) {
        if (topObjectId == g_sprayManagerCategory) {
            Format(buffer, maxLength, "%T", SPRAY_MANAGER, param);
        }
    } else if (action == TopMenuAction_SelectOption) {
        if (topObjectId == g_menuItemTraceSpray) {
            UseCase_TraceAndGetSprayInfo(param);
            Menu_ShowCategory(param);
        } else if (topObjectId == g_menuItemRemoveSpray) {
            UseCase_TraceAndRemoveSpray(param);
            Menu_ShowCategory(param);
        } else if (topObjectId == g_menuItemRemoveAllSprays) {
            UseCase_RemoveAllSprays(param);
            Menu_ShowCategory(param);
        } else if (topObjectId == g_menuItemDrawSpray) {
            Menu_DrawSpray(param);
        }
    }
}

void Menu_ShowCategory(int client) {
    g_adminMenu.DisplayCategory(g_sprayManagerCategory, client);
}

void Menu_DrawSpray(int client) {
    Menu menu = new Menu(MenuHandler_DrawSpray);

    menu.SetTitle("%T", ITEM_SPRAY_DRAW, client);

    Menu_AddPlayers(menu);

    menu.ExitBackButton = true;
    menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandler_DrawSpray(Menu menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        char info[INFO_MAX_SIZE];

        menu.GetItem(param2, info, sizeof(info));

        int targetId = StringToInt(info);
        int target = GetClientOfUserId(targetId);

        if (target == INVALID_CLIENT) {
            MessageReply_PlayerNoLongerAvailable(param1);
        } else {
            UseCase_DrawSpray(param1, target);
        }

        Menu_DrawSpray(param1);
    } else if (action == MenuAction_Cancel && param2 == MenuCancel_ExitBack) {
        Menu_ShowCategory(param1);
    } else if (action == MenuAction_End) {
        delete menu;
    }

    return 0;
}

void Menu_AddPlayers(Menu menu) {
    char info[INFO_MAX_SIZE];
    char item[ITEM_MAX_SIZE];

    for (int i = 1; i <= MaxClients; i++) {
        if (!IsClientInGame(i) || IsFakeClient(i)) {
            continue;
        }

        int userId = GetClientUserId(i);

        IntToString(userId, info, sizeof(info));
        GetClientName(i, item, sizeof(item));

        menu.AddItem(info, item);
    }
}
