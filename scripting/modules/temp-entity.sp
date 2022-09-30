void TempEntity_HookSpray() {
    AddTempEntHook(DECAL_SPRAY, TempEntityHook_Spray);
}

void TempEntity_UnhookSpray() {
    RemoveTempEntHook(DECAL_SPRAY, TempEntityHook_Spray);
}

public Action TempEntityHook_Spray(const char[] tempEntityName, const int[] clients, int clientsAmount, float delay) {
    int client = TE_ReadNum(DECAL_OWNER);
    float sprayPosition[VECTOR_SIZE];

    TE_ReadVector(DECAL_POSITION, sprayPosition);
    UseCase_SaveSpray(client, sprayPosition);

    return Plugin_Continue;
}

void TempEntity_Spray(int client, const float sprayPosition[VECTOR_SIZE]) {
    TE_Start(DECAL_SPRAY);
    TE_WriteVector(DECAL_POSITION, sprayPosition);
    TE_WriteNum(DECAL_OWNER, client);
    TE_WriteNum(DECAL_ENTITY, ENTITY_WORLD);
    TE_SendToAll();
}
