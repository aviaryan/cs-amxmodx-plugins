/* 
Kills123

Gives 3-kill points for knife kills and 2-kill points for pistol kills.

Enable/Disable
	kills123 1
	kills123 0
	

Thanks to Rul4's Knife Double frags (kdf), This is based on that.
*/


#include <amxmodx>
#include <amxmisc>
#include <fun>

#define PLUGIN "Kills 123"
#define VERSION "0.1"
#define AUTHOR "aviaryan"

new kills123_enabled, sounds;


new knife_pun_list[][] =
{
	"%s was stabbed to death by %s",
	"%s is a piece of meat now, thanks to %s",
	"%s was killed via knife by %s, What a disgrace !"
};

new pistol_pun_list[][] = 
{
	"%s was glocked to death by %s",
	"%s was pulled down by a pistol, How sad is that !"
};

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
	register_event("DeathMsg","hook_death","a");
	kills123_enabled = register_cvar("kills123", "1"); // returns a ptr to var kills123_enabled
	sounds = register_cvar("kills123_sounds","1");
	console_print(0, "*** %s plugin by %s (http://aviaryan.in) ***", PLUGIN, AUTHOR);
}

public plugin_precache()
{
	precache_sound("misc/humiliation.wav"); // the file may not be available in 1.6 . Get it from Zero
}

public hook_death()
{
	if(get_pcvar_num(kills123_enabled) != 1)
		return PLUGIN_HANDLED;
	
	new killer = read_data(1);
	new victim = read_data(2);
	new kname[64]; get_user_name(killer,kname,63);
	new vname[64]; get_user_name(victim,vname,63);
	new weapon[24];
	read_data(4,weapon,23);
	
	if(get_user_team(killer) != get_user_team(victim))
	{
		
		if (strcmp(weapon,"knife") == 0)
		{
			client_print(0, print_chat, knife_pun_list[random(sizeof knife_pun_list)], vname, kname);
			inc_frag(killer, 2);
			if(bsounds(sounds)) client_cmd(0,"spk misc/humiliation");
		}
		else if (ispistol(weapon))
		{
			client_print(0, print_chat, pistol_pun_list[random(sizeof pistol_pun_list)], vname, kname);
			inc_frag(killer, 1);
		}

	}

	return PLUGIN_HANDLED;
}

inc_frag(index, bywhat)
{
	if(!is_user_connected(index)) return;
	set_user_frags(index,get_user_frags(index)+bywhat);
}

bool: ispistol(weapon[])
{
	return !( strcmp(weapon,"p228") && strcmp(weapon,"elite") && strcmp(weapon,"fiveseven") && strcmp(weapon,"usp") && strcmp(weapon,"glock18") && strcmp(weapon,"deagle") );
}

bool: bsounds(pcvar)
{
	if(get_pcvar_num(pcvar) == 1)
		return true;
	return false;
}
