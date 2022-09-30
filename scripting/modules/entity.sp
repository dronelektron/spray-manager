void Entity_TraceEndPosition(int client, float endPosition[VECTOR_SIZE]) {
    float eyesPosition[VECTOR_SIZE];
    float eyesAngles[VECTOR_SIZE];

    GetClientEyePosition(client, eyesPosition);
    GetClientEyeAngles(client, eyesAngles);

    Handle trace = TR_TraceRayFilterEx(eyesPosition, eyesAngles, MASK_SHOT, RayType_Infinite, TraceEntityFilter_Players);

    TR_GetEndPosition(endPosition, trace);
    CloseHandle(trace);
}

bool TraceEntityFilter_Players(int entity, int contentsMask) {
    return entity > MaxClients;
}
