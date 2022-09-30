void UseCase_SaveSpray(int client, const float sprayPosition[VECTOR_SIZE]) {
    Client_MarkSprayOwner(client);
    Client_SetSprayPosition(client, sprayPosition);
    Client_MarkSprayTimestamp(client);
}

void UseCase_TraceAndGetSprayInfo(int client) {
    int target = UseCase_TraceSpray(client);

    if (target == CLIENT_NOT_FOUND) {
        MessageReply_SprayNotFound(client);
    } else {
        UseCase_GetSprayInfo(client, target);
    }
}

void UseCase_GetSprayInfo(int client, int target) {
    int sprayTimestamp = Client_GetSprayTimestamp(target);
    char steam[MAX_AUTHID_LENGTH];
    char time[TIME_MAX_SIZE];

    GetClientAuthId(target, AuthId_Steam3, steam, sizeof(steam));
    FormatTime(time, sizeof(time), NULL_STRING, sprayTimestamp);
    MessageHint_SprayInfo(client, target, steam, time);
}

void UseCase_TraceAndRemoveSpray(int client) {
    int target = UseCase_TraceSpray(client);

    if (target == CLIENT_NOT_FOUND) {
        MessageReply_SprayNotFound(client);
    } else {
        UseCase_RemoveSpray(target);
        Message_SprayRemoved(client, target);
    }
}

void UseCase_RemoveAllSprays(int client) {
    for (int i = 1; i <= MaxClients; i++) {
        if (Client_HasSpray(i)) {
            UseCase_RemoveSpray(i);
        }
    }

    Message_AllSpraysRemoved(client);
}

void UseCase_RemoveSpray(int client) {
    UseCase_Spray(client, VECTOR_MAX);
    Client_UnmarkSprayOwner(client);
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
    int closestSprayOwner = CLIENT_NOT_FOUND;

    Entity_TraceEndPosition(client, endPosition);

    for (int i = 1; i <= MaxClients; i++) {
        if (!Client_HasSpray(i)) {
            continue;
        }

        Client_GetSprayPosition(i, sprayPosition);

        float sprayDistance = GetVectorDistance(endPosition, sprayPosition);

        if (sprayDistance < closestSprayDistance) {
            closestSprayDistance = sprayDistance;
            closestSprayOwner = i;
        }
    }

    return closestSprayOwner;
}
