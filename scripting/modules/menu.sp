static TopMenu g_adminMenu = null;

static TopMenuObject g_sprayManagerCategory = INVALID_TOPMENUOBJECT;
static TopMenuObject g_menuItemTraceSpray = INVALID_TOPMENUOBJECT;
static TopMenuObject g_menuItemRemoveSpray = INVALID_TOPMENUOBJECT;
static TopMenuObject g_menuItemRemoveAllSprays = INVALID_TOPMENUOBJECT;

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
    }
}

TopMenuObject AdminMenu_AddItem(const char[] name) {
    return g_adminMenu.AddItem(name, AdminMenuHandler_SprayManager, g_sprayManagerCategory);
}

public void AdminMenuHandler_SprayManager(TopMenu topmenu, TopMenuAction action, TopMenuObject topobj_id, int param, char[] buffer, int maxlength) {
    if (action == TopMenuAction_DisplayOption) {
        if (topobj_id == g_sprayManagerCategory) {
            Format(buffer, maxlength, "%T", SPRAY_MANAGER, param);
        } else if (topobj_id == g_menuItemTraceSpray) {
            Format(buffer, maxlength, "%T", ITEM_SPRAY_TRACE, param);
        } else if (topobj_id == g_menuItemRemoveSpray) {
            Format(buffer, maxlength, "%T", ITEM_SPRAY_REMOVE, param);
        } else if (topobj_id == g_menuItemRemoveAllSprays) {
            Format(buffer, maxlength, "%T", ITEM_SPRAY_REMOVE_ALL, param);
        }
    } else if (action == TopMenuAction_DisplayTitle) {
        if (topobj_id == g_sprayManagerCategory) {
            Format(buffer, maxlength, "%T", SPRAY_MANAGER, param);
        }
    } else if (action == TopMenuAction_SelectOption) {
        if (topobj_id == g_menuItemTraceSpray) {
            UseCase_TraceAndGetSprayInfo(param);
        } else if (topobj_id == g_menuItemRemoveSpray) {
            UseCase_TraceAndRemoveSpray(param);
        } else if (topobj_id == g_menuItemRemoveAllSprays) {
            UseCase_RemoveAllSprays(param);
        }

        topmenu.DisplayCategory(g_sprayManagerCategory, param);
    }
}
