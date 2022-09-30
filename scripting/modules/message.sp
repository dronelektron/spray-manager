void MessageReply_SprayNotFound(int client) {
    ReplyToCommand(client, "%s%t", PREFIX, "Spray not found");
}

void MessageHint_SprayInfo(int client, int target, const char[] steam, const char[] time) {
    PrintHintText(client, "%t", "Spray info", target, steam, time);
}

void Message_SprayRemoved(int client, int target) {
    ShowActivity2(client, PREFIX, "%t", "Spray removed", target);
    LogMessage("\"%L\" removed spray \"%L\"", client, target);
}

void Message_AllSpraysRemoved(int client) {
    ShowActivity2(client, PREFIX, "%t", "All sprays removed");
    LogMessage("\"%L\" removed all sprays", client);
}
