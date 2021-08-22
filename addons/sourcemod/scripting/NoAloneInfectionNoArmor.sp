#include <sourcemod>
#include <zombiereloaded>
#include <multicolors>

ConVar g_InfectionMinPlayer;
ConVar g_InfectionArmorZombie;
ConVar g_InfectionArmorHuman;

public Plugin myinfo = 
{
	name = "[ZR] No Alone Infection & No Armor",
	author = "DSASDFGH, REZOR, Modified by. Someone, maxime1907",
	description = "Control min number of players for infection and zm/human armor amount",
	version = "1.2",
	url = "https://gitlab.com/counterstrikeglobaloffensive/sm-plugins/noaloneinfectionnoarmor"
}

public OnPluginStart()
{
	g_InfectionMinPlayer = CreateConVar("zr_infect_min_players", "2", "Minimum number of players to start the infection", FCVAR_NOTIFY, true, 0.0, true, 64.0);
	g_InfectionArmorZombie = CreateConVar("zr_armor_zombie", "0", "Armor amount for zombies", FCVAR_NOTIFY, true, 0.0, true, 100.0);
	g_InfectionArmorHuman = CreateConVar("zr_armor_human", "100", "Armor amount for humans", FCVAR_NOTIFY, true, 0.0, true, 100.0);

	HookEvent("player_spawn", Hook_OnSpawn);
	
	AutoExecConfig(true);
}

public OnPluginEnd()
{
    UnhookEvent("player_spawn", Hook_OnSpawn)
}

public Action ZR_OnClientInfect(&client, &attacker, &bool:motherInfect, &bool:respawnOverride, &bool:respawn)
{
	int players = GetClientCount(true);

	if (players <= g_InfectionMinPlayer.IntValue)
	{
		CPrintToChatAll("{green}[ZR]{lightred} There aren't enough players to start the infection cycle.");
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

public void ZR_OnClientInfected(client, attacker, bool:motherInfect, bool:respawnOverride, bool:respawn)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client))
		return;

	SetEntProp(client, Prop_Send, "m_ArmorValue", g_InfectionArmorZombie.IntValue, 1);
}

public Action Hook_OnSpawn(Handle event, const char[] name, bool dontBroadcast) 
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if (!IsClientInGame(client) || !IsPlayerAlive(client) || !ZR_IsClientHuman(client))
		return Plugin_Continue;

	SetEntProp(client, Prop_Send, "m_ArmorValue", g_InfectionArmorHuman.IntValue, 1);
}
