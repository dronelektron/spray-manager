void Command_Create() {
    RegAdminCmd("sm_spraymanager_trace", Command_TraceSpray, ADMFLAG_GENERIC);
    RegAdminCmd("sm_spraymanager_remove", Command_RemoveSpray, ADMFLAG_GENERIC);
    RegAdminCmd("sm_spraymanager_remove_all", Command_RemoveAllSprays, ADMFLAG_GENERIC);
    RegAdminCmd("sm_spraymanager_draw", Command_DrawSpray, ADMFLAG_GENERIC);
}

public Action Command_TraceSpray(int client, int args) {
    UseCase_TraceAndGetSprayInfo(client);

    return Plugin_Handled;
}

public Action Command_RemoveSpray(int client, int args) {
    UseCase_TraceAndRemoveSpray(client);

    return Plugin_Handled;
}

public Action Command_RemoveAllSprays(int client, int args) {
    UseCase_RemoveAllSprays(client);

    return Plugin_Handled;
}

public Action Command_DrawSpray(int client, int args) {
    if (args < 1) {
        MessageReply_DrawSprayUsage(client);

        return Plugin_Handled;
    }

    char name[MAX_NAME_LENGTH];

    GetCmdArg(1, name, sizeof(name));

    int target = FindTarget(client, name);

    if (target != CLIENT_NOT_FOUND) {
        UseCase_DrawSpray(client, target);
    }

    return Plugin_Handled;
}
