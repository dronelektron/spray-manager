void Sound_Precache() {
    PrecacheSound(SOUND_SPRAY, PRELOAD_YES);
}

void Sound_Spray(int client) {
    EmitSoundToAll(SOUND_SPRAY, client, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 1.0);
}
