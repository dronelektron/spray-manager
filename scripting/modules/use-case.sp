void UseCase_SaveSpray(int client, const float position[VECTOR_SIZE]) {
    char name[MAX_NAME_LENGTH];
    char steam[MAX_AUTHID_LENGTH];
    int timestamp = GetTime();

    UseCase_GetName(client, name);
    UseCase_GetSteam(client, steam);

    int sprayIndex = UseCase_FindSprayByClient(client);

    if (sprayIndex != SPRAY_INDEX_NOT_FOUND) {
        SprayList_Remove(sprayIndex);
    }

    SprayList_Add(name, steam, position, timestamp, client);
}

void UseCase_SetClientForSpray(int client) {
    char steam[MAX_AUTHID_LENGTH];

    UseCase_GetSteam(client, steam);

    int sprayIndex = UseCase_FindSprayBySteam(steam);

    if (sprayIndex != SPRAY_INDEX_NOT_FOUND) {
        SprayList_SetClient(sprayIndex, client);
    }
}

void UseCase_RemoveClientFromSpray(int client) {
    int sprayIndex = UseCase_FindSprayByClient(client);

    if (sprayIndex != SPRAY_INDEX_NOT_FOUND) {
        SprayList_SetClient(sprayIndex, CLIENT_NOT_FOUND);
    }
}

void UseCase_SetClientNameForSpray(int client, const char[] name) {
    int sprayIndex = UseCase_FindSprayByClient(client);

    if (sprayIndex != SPRAY_INDEX_NOT_FOUND) {
        SprayList_SetName(sprayIndex, name);
    }
}

void UseCase_TraceAndGetSprayInfo(int client) {
    int sprayIndex = UseCase_TraceSpray(client);

    if (sprayIndex == SPRAY_INDEX_NOT_FOUND) {
        MessageReply_SprayNotFound(client);
    } else {
        UseCase_GetSprayInfo(client, sprayIndex);
    }
}

void UseCase_GetSprayInfo(int client, int sprayIndex) {
    char name[MAX_NAME_LENGTH];
    char steam[MAX_AUTHID_LENGTH];
    char time[TIME_MAX_SIZE];
    int timestamp = SprayList_GetTimestamp(sprayIndex);

    SprayList_GetName(sprayIndex, name);
    SprayList_GetSteam(sprayIndex, steam);
    FormatTime(time, TIME_MAX_SIZE, TIME_FORMAT, timestamp);
    MessageHint_SprayInfo(client, name, steam, time);
}

void UseCase_RemoveSprayQuickly(int client) {
    int sprayIndex = UseCase_TraceSpray(client);

    if (sprayIndex == SPRAY_INDEX_NOT_FOUND) {
        MessageReply_SprayNotFound(client);
    } else {
        int target = SprayList_GetClient(sprayIndex);

        if (target == CLIENT_NOT_FOUND) {
            MessageReply_YouCannotRemoveSpray(client);
        } else {
            UseCase_RemoveSprayAndNotify(sprayIndex, client, target);
        }
    }
}

void UseCase_RemoveAllSprays(int client) {
    int spraysOldAmount = SprayList_Size();

    for (int sprayIndex = 0; sprayIndex < spraysOldAmount; sprayIndex++) {
        int target = SprayList_GetClient(sprayIndex);

        if (target != CLIENT_NOT_FOUND) {
            UseCase_RemoveSpray(sprayIndex, target);
        }
    }

    int spraysNewAmount = SprayList_Size();

    if (spraysNewAmount == spraysOldAmount) {
        MessageReply_SpraysNotFoundOrCannotBeRemoved(client);
    } else if (spraysNewAmount > 0) {
        Message_SomeSpraysRemoved(client);
    } else {
        Message_AllSpraysRemoved(client);
    }
}

void UseCase_RemoveSprayByTarget(int client, int target) {
    int sprayIndex = UseCase_FindSprayByClient(target);

    if (sprayIndex == SPRAY_INDEX_NOT_FOUND) {
        MessageReply_SprayNotFound(client);
    } else {
        UseCase_RemoveSprayAndNotify(sprayIndex, client, target);
    }
}

void UseCase_RemoveSprayAndNotify(int sprayIndex, int client, int target) {
    UseCase_RemoveSpray(sprayIndex, target);
    Message_SprayRemoved(client, target);
}

void UseCase_RemoveSpray(int sprayIndex, int client) {
    UseCase_Spray(client, VECTOR_MAX);
    SprayList_Remove(sprayIndex);
}

void UseCase_DrawSpray(int client, int target) {
    float endPosition[VECTOR_SIZE];

    Entity_TraceEndPosition(client, endPosition);
    UseCase_Spray(target, endPosition);
    Sound_Spray(client);
    Message_SprayDrawn(client, target);
}

void UseCase_Spray(int client, const float sprayPosition[VECTOR_SIZE]) {
    if (IsClientInGame(client)) {
        TempEntity_Spray(client, sprayPosition);
    }
}

int UseCase_TraceSpray(int client) {
    float endPosition[VECTOR_SIZE];
    float sprayPosition[VECTOR_SIZE];
    float closestSprayDistance = SPRAY_DISTANCE_MAX;
    int closestSprayIndex = SPRAY_INDEX_NOT_FOUND;

    Entity_TraceEndPosition(client, endPosition);

    for (int i = 0; i < SprayList_Size(); i++) {
        SprayList_GetPosition(i, sprayPosition);

        float sprayDistance = GetVectorDistance(endPosition, sprayPosition);

        if (sprayDistance < closestSprayDistance) {
            closestSprayDistance = sprayDistance;
            closestSprayIndex = i;
        }
    }

    return closestSprayIndex;
}

int UseCase_FindSprayByClient(int client) {
    for (int sprayIndex = 0; sprayIndex < SprayList_Size(); sprayIndex++) {
        int tempClient = SprayList_GetClient(sprayIndex);

        if (tempClient == client) {
            return sprayIndex;
        }
    }

    return SPRAY_INDEX_NOT_FOUND;
}

int UseCase_FindSprayBySteam(const char[] steam) {
    char tempSteam[MAX_AUTHID_LENGTH];

    for (int sprayIndex = 0; sprayIndex < SprayList_Size(); sprayIndex++) {
        SprayList_GetSteam(sprayIndex, tempSteam);

        if (strcmp(steam, tempSteam) == 0) {
            return sprayIndex;
        }
    }

    return SPRAY_INDEX_NOT_FOUND;
}

void UseCase_GetName(int client, char[] name) {
    GetClientName(client, name, MAX_NAME_LENGTH);
}

void UseCase_GetSteam(int client, char[] steam) {
    GetClientAuthId(client, AuthId_Steam3, steam, MAX_AUTHID_LENGTH);
}
