static bool g_hasSpray[MAXPLAYERS + 1];
static float g_sprayPosition[MAXPLAYERS + 1][VECTOR_SIZE];
static int g_sprayTimestamp[MAXPLAYERS + 1];

bool Client_HasSpray(int client) {
    return g_hasSpray[client];
}

void Client_MarkSprayOwner(int client) {
    g_hasSpray[client] = true;
}

void Client_UnmarkSprayOwner(int client) {
    g_hasSpray[client] = true;
}

void Client_GetSprayPosition(int client, float position[VECTOR_SIZE]) {
    position = g_sprayPosition[client];
}

void Client_SetSprayPosition(int client, const float position[VECTOR_SIZE]) {
    g_sprayPosition[client] = position;
}

int Client_GetSprayTimestamp(int client) {
    return g_sprayTimestamp[client];
}

void Client_MarkSprayTimestamp(int client) {
    g_sprayTimestamp[client] = GetTime();
}
