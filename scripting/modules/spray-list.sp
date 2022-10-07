static ArrayList g_sprays = null;

void SprayList_Create() {
    int blockSize = ByteCountToCells(MAX_NAME_LENGTH);

    g_sprays = new ArrayList(blockSize);
}

void SprayList_Destroy() {
    delete g_sprays;
}

void SprayList_Clear() {
    g_sprays.Clear();
}

int SprayList_Size() {
    return g_sprays.Length / FIELDS_AMOUNT;
}

void SprayList_Add(const char[] name, const char[] steam, const float position[VECTOR_SIZE], int timestamp, int client) {
    g_sprays.PushString(name);
    g_sprays.PushString(steam);
    g_sprays.PushArray(position, VECTOR_SIZE);
    g_sprays.Push(timestamp);
    g_sprays.Push(client);
}

void SprayList_Remove(int index) {
    int offset = SprayList_Offset(index);

    g_sprays.Erase(offset + FIELD_CLIENT);
    g_sprays.Erase(offset + FIELD_TIMESTAMP);
    g_sprays.Erase(offset + FIELD_POSITION);
    g_sprays.Erase(offset + FIELD_STEAM);
    g_sprays.Erase(offset + FIELD_NAME);
}

void SprayList_GetName(int index, char[] name) {
    int offset = SprayList_Offset(index) + FIELD_NAME;

    g_sprays.GetString(offset, name, MAX_NAME_LENGTH);
}

void SprayList_SetName(int index, const char[] name) {
    int offset = SprayList_Offset(index) + FIELD_NAME;

    g_sprays.SetString(offset, name);
}

void SprayList_GetSteam(int index, char[] steam) {
    int offset = SprayList_Offset(index) + FIELD_STEAM;

    g_sprays.GetString(offset, steam, MAX_AUTHID_LENGTH);
}

void SprayList_GetPosition(int index, float position[VECTOR_SIZE]) {
    int offset = SprayList_Offset(index) + FIELD_POSITION;

    g_sprays.GetArray(offset, position, VECTOR_SIZE);
}

int SprayList_GetTimestamp(int index) {
    int offset = SprayList_Offset(index) + FIELD_TIMESTAMP;

    return g_sprays.Get(offset);
}

int SprayList_GetClient(int index) {
    int offset = SprayList_Offset(index) + FIELD_CLIENT;

    return g_sprays.Get(offset);
}

void SprayList_SetClient(int index, int client) {
    int offset = SprayList_Offset(index) + FIELD_CLIENT;

    g_sprays.Set(offset, client);
}

int SprayList_Offset(int index) {
    return index * FIELDS_AMOUNT;
}
