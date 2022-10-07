void MessageReply_SprayNotFound(int client) {
    ReplyToCommand(client, "%s%t", PREFIX, "Spray not found");
}

void MessageReply_YouCannotRemoveSpray(int client) {
    ReplyToCommand(client, "%s%t", PREFIX, "You cannot remove spray");
}

void MessageHint_SprayInfo(int client, const char[] name, const char[] steam, const char[] time) {
    PrintHintText(client, "%t", "Spray info", name, steam, time);
}

void Message_SprayRemoved(int client, int target) {
    ShowActivity2(client, PREFIX, "%t", "Spray removed", target);
    LogMessage("\"%L\" removed spray \"%L\"", client, target);
}

void MessageReply_SpraysNotFoundOrCannotBeRemoved(int client) {
    ReplyToCommand(client, "%s%t", PREFIX, "Sprays not found or cannot be removed");
}

void Message_SomeSpraysRemoved(int client) {
    ShowActivity2(client, PREFIX, "%t", "Some sprays removed");
    LogMessage("\"%L\" removed some sprays", client);
}

void Message_AllSpraysRemoved(int client) {
    ShowActivity2(client, PREFIX, "%t", "All sprays removed");
    LogMessage("\"%L\" removed all sprays", client);
}

void MessageReply_RemoveSprayUsage(int client) {
    ReplyToCommand(client, "%s%s", PREFIX, "Usage: sm_spraymanager_remove <#userid|name>");
}

void MessageReply_DrawSprayUsage(int client) {
    ReplyToCommand(client, "%s%s", PREFIX, "Usage: sm_spraymanager_draw <#userid|name>");
}

void MessageReply_PlayerNoLongerAvailable(int client) {
    ReplyToCommand(client, "%s%t", PREFIX, "Player no longer available");
}

void Message_SprayDrawn(int client, int target) {
    ShowActivity2(client, PREFIX, "%t", "Spray drawn", target);
    LogMessage("\"%L\" drawn spray \"%L\"", client, target);
}
