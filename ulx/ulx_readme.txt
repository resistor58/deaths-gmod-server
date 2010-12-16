Title: ULX Readme

__ULX__
Version 3.40

*ULX v3.40 (released 06/20/09)*

ULX is an admin mod for GMod (<http://garrysmod.com/>).

ULX offers server admins an AMXX-style support. It allows multiple admins with different access levels on the same server. 
It has features from basic kick, ban, and slay to fancier commands such as blind, freeze, voting, and more.

Visit our homepage at <http://ulyssesmod.net/>.

You can talk to us on our forums at <http://forums.ulyssesmod.net/>

Group: Author

ULX is brought to you by..

* Brett "Megiddo" Smith - Contact: <megiddo@ulyssesmod.net>
* JamminR - Contact: <jamminr@ulyssesmod.net>
* Spbogie - Contact: <spbogie@ulyssesmod.net>

Group: Requirements

ULX requires the latest ULib to be installed on the server. You can get ULib from the ULX homepage.

Group: Installation

To install ULX, simply extract the files from the archive to your garrysmod/addons folder.
When you've done this, you should have a file structure like this--
<garrysmod>/addons/ulx/lua/ULib/modules/ulx_init.lua
<garrysmod>/addons/ulx/lua/ulx/modules/fun.lua
etc..

Note that installation for dedicated servers is EXACTLY the same!

You absolutely, positively have to do a full server restart after installing the files. A simple map
change will not cut it!

Group: Usage

To use ULX, simply type in whatever command or cvar you want to use. If you're not running a listen server, 
or if you want to give access to other users, you must add users. 

You can either follow the standard GM10 way of adding users 
(http://wiki.garrysmod.com/wiki/?title=Player_Groups), or you can add yourself directly to the
data/ULib/users.txt file. DO NOT EDIT THE ULIB FILE UNLESS YOU KNOW WHAT YOU'RE DOING.

A word about superadmins: Superadmins are considered the highest usergroup. They have access to all the
commands in ULX, override other user's immunity, and are shown otherwise hidden log messages (IE, shown
rcon commands admins are running, when they spectate others). Superadmins also have the power to give and
revoke access to commands using userallow and userdeny (though they can't use this command on eachother).

All commands are now preceded by "ulx ". Type "ulx help" in a console without the quotes for help.
This is different from ulx v1 where commands were preceded by "ulx_".

__To give yourself a jump start into ulx, simply remember the commands "ulx help" and "ulx menu". You can
also access the menu by saying "!menu".__

Check out the configs folder in ulx for some more goodies.

Group: Changelog
v3.40 - *(06/20/09)*
	* [ADD] Alltalk to the admin menu
	* [FIX] Umsgs being sent too early in certain circumstances.
	* [FIX] The .ini files not loading properly on listen servers.
	* [FIX] Problems introduced by garry's changes in handling concommands
	* [FIX] Changed ULX_README.TXT file to point to proper instruction link for editing Gmod default users.
	* [FIX] Removed a patch for a garrysmod autocomplete bug that's now fixed.
	* [FIX] Maps not being sent correctly to the client.
	* [FIX] Can't create a vote twice anymore.
	* [FIX] A bug with loading the map list on listen server hosts.
	* [FIX] An unfreeze bug with the ulx jail walls.
	* [FIX] A caps bug with ulx adduserid.
	* [FIX] You can now unragdoll yourself even if a third party addon removes the ragdoll.
	* [FIX] Various formatting issues with ulx ban and ulx banid.
	* [CHANGE] ulx ragdoll and unragdoll now preserve angle and velocity.
	* [CHANGE] motdfile cvar now defaults to ulx_motd.txt. Sick of forcefully overriding other mod's motds. Renamed our motd to match.
	* [CHANGE] ulx slap, whip, hp to further prevent being "stuck in ground".
	* [CHANGE] Menus are derma'tized.
	* [CHANGE] Updated how it handles svn version information.

v3.31 - *(06/08/08)*
	* [ADD] ulx adduserid - Add a user by steam id (ie STEAM_0:1:1234...) (Does not actually verify user validity) (Thanks Mr.President)
	* [FIX] Garry's 1/29/08 update breaking MOTD.
	* [FIX] Links not working on MOTD.
	* [FIX] Bug where you'd be stuck if someone disconnected while you were spectating them.
	* [FIX] TF2 motd showing by default.
	* [FIX] The usual assortment of small fixes not worth mentioning.	
	* [CHANGE] Unignite help command changed to be more standardized with other help.
	* [CHANGE] Help indicates that multiple users can now also be command targeted using an asterisk "*". (ULib change added this)
	* [CHANGE] Miscellaneous spelling corrections.
	* [CHANGE] ulx chattime so that if your chat doesn't go through it is not counted towards your time.
	* [CHANGE] Can no longer set hp or armor to less than 0.
	* [REMOVE] ulx mingekick, useless now.

v3.30 - *(01/26/08)*
	* [ADD] ulx strip - Strips player(s) weapons
	* [ADD] ulx armor - Sets player(s) armor
	* [ADD] We now log NPC spawns
	* [ADD] ulx unignite - Unignites individual player, <all> players, or <everything> Any entity/player on fire.
	* [FIX] ulx ban requiring a reason.
	* [FIX] Added some more sanity checks to ulx maul.
	* [FIX] The usual assortment of small fixes not worth mentioning.
	* [FIX] ulx usermanagementhelp erroring out.
	* [FIX] .ini's not loading for listen servers.
	* [FIX] Case sensitivity problem with addgroup and removegroup.
	* [FIX] ulx ent incorrectly requiring at least one flag.
	* [FIX] All command inputs involving numbers should now be sanitized.
	* [FIX] Autocomplete send in a multi-layer authentication environment (probably doesn't affect anyone)
	* [CHANGE] The 0-255 scale for "ulx cloak" has been reversed.
	* [CHANGE] Model paths in logging is now standardized (linux notation, single slashes)
	* [CHANGE] The user initiating a silent logged command still sees the echo, even if they don't have access to see it normally.
	* [CHANGE] Various misc things for new engine compatibility (IE, ulx clientmenu got a major change and other menu changes)
	* [CHANGE] Removed all timers dealing with initialization and now rely on flags from the client. This makes the ULX initialization much more dependable.
	* [CHANGE] Name change watching is now taken care of by ULib.
	* [CHANGE] Converted all calls from ULib.consoleCommand( "exec ..." ) to ULib.execFile() to avoid running into the block on "exec" without our module.


v3.20 - *(09/23/07)*
	* [ADD] ulx send - Allows admin to transport a player to another player (no more goto then bring!)
	* [ADD] ulx maul - Maul a player with fast zombies
	* [ADD] ulx gag - Silence individual player's microphone/sound input on voice enabled servers.
	* [ADD] New module system. It's now easier than ever to add, remove, or change ULX commands!
	* [ADD] ulx.addToMenu(). Use this function if you want a module to add something to any of the ULX menu.
	* [ADD] ulx debuginfo. Use this function to get information to give us when you're asking support questions.
	* [ADD] Votes now have a background behind them.
	* [ADD] ulx voteEcho. A config option to enable echo of votes. Does not apply to votemap.
	* [ADD] Maps menu now has option for gamemode.
	* [ADD] Ban menu to view and remove bans.
	* [ADD] ulx removeruser, addgroup, removegroup, groupallow, groupdeny, usermanagementhelp
	* [FIX] ulx whip - No longer allows multiple whip sessions of an individual player at same time.
	* [FIX] ulx adduser - You no longer have to reconnect to get given access.
	* [FIX] Vastly improved ulx send, goto, and teleport. You should never get stuck in anything ever again.
	* [FIX] Various initialization functions trying to access a disconnected player
	* [FIX] Vastly improved reserved slots
	* [FIX] Can't spawn junk or suicide while frozen now.
	* [FIX] Coming out of spectate keeps god mode (if the player was given god with "ulx god")
	* [FIX] Can't use "ulx hp" to give 100000+ hp anymore (crashes players with default HUD).
	* [FIX] If you're authed twice, you won't get duplicates in autocomplete
	* [FIX] ulx votemapmapmode and votemapaddmap not working
	* [CHANGE] /me <action> can now be used in ulx asay/chat @ admin chat. "@ /me bashes spammer over the head"
	* [CHANGE] Commands that used player:spawn (ragdoll,spectate, more) now return player to health/armor they had previously.
	* [CHANGE] ulx teleport. Can now teleport a player to where you are looking. Logs it if a player is specified.
	* [CHANGE] You can now specify entire directories in ulx addForcedDownload
	* [CHANGE] A few internal changes to the ULX base to compliment the new ULib UCL access string system
	* [CHANGE] ULX echoes come after the command now.
	* [CHANGE] Configs are now under /cfg/* instead of /lua/ulx/configs/*
	* [CHANGE] bring goto and teleport now zero out your velocity after moving you.
	* [CHANGE] bring and goto can now still move you when you would get stuck if you're noclipped.
	* [CHANGE] A hidden echo that is still shown to admins is now clearly labeled as such.
	* [CHANGE] ulx cexec now takes multiple targets. (This was the intended behavior)
	* [CHANGE] Lots of minor tweaks that would take too long to list. ;)
	* [CHANGE] All say commands require spaces after them except the "@" commands. (IE, "!slapbob" no longer slaps bob)
	* [CHANGE] Access to physgun players now uses the access string "ulx physgunplayer"
	* [CHANGE] Access to reserved slots now uses the access string "ulx reservedslots"
	* [CHANGE] Complete rewrite of advert system. You probably won't notice any difference (except hostname fix), but the code is leaner and meaner.
	* [CHANGE] No interval option for ulx whip anymore, too easy to abuse.
	* [CHANGE] Menus now use derma
	* [CHANGE] The ULX configs should now really and truly load after the default configs
	* [CHANGE] Votemap, votekick, voteban now all require the approval of the admin that started the vote if it wins.
	* [CHANGE] Voteban can now receive a parameter for ban time.
	* [CHANGE] ulx map can now receive gamemode for a parameter.
	* [CHANGE] You can now use newlines in adverts.
	* [CHANGE] Dropped requirement of being at least an opper for userallow/deny
	* [CHANGE] ulx who has an updated format that includes custom groups.
	* [CHANGE] ulx help is now categorized. (Reserved slots, teleportation, chat, etc )
	* [CHANGE] ulx thetime can now only be used once every minute (server wide)

v3.11 - *(06/19/07)*
	* [FIX] ulx vote. No longer public, people can't vote more than once, won't continue to hog the binds.
	* [FIX] rslots will now set rslots on dedicated server start
	* [FIX] Bring/goto getting you stuck in player sometimes.
	* [FIX] Can't use vehicles from inside a jail now.
	* [CHANGE] bring and goto now place teleporting player behind target
	* [CHANGE] Upped votemapMinvotes to 3 (was 2).
	* [CHANGE] Player physgun now only works in sandbox, lower admins can't physgun immune admins, freezes player while held.
	* [CHANGE] Unblocked custom groups from ulx adduser.

v3.10 - *(05/05/07)*
	* [ADD] Admins with slap access can move players now.
	* [ADD] Chat anti-spam
	* [ADD] ulx addForcedDownload for configs
	* [ADD] Per-gamemode config folder
	* [ADD] Voting! ulx vote, ulx votemap2, ulx voteban, ulx votekick
	* [ADD] Maps menu
	* [ADD] Lots more features to logging, like object spawn logging.
	* [ADD] Reserved slots
	* [FIX] Lots of minor insignificant bugs
	* [FIX] Jail issues
	* [FIX] Logging player connect on dedicated server issues
	* [FIX] Now takes advantage of fixed umsgs. Fixes rare crash.
	* [FIX] Can now psay immune players
	* [FIX] Minor bugs in logs
	* [CHANGE] Logs will now wrap to new date if server's on past midnight
	* [CHANGE] You can now use the admin menu in gamemodes derived from sandbox.
	* [CHANGE] Cleaned up now obsolete GetTable() calls
	* [CHANGE] Motd is now driven by lua. Much easier to deal with, fixes many problems.
	* [CHANGE] Can now use sv_cheats 1/0 from ulx rcon (dodges block)
	* [CHANGE] ulx lua_run is now ulx luarun to dodge another block
	* [CHANGE] Now in addon format
	* [CHANGE] ulx ignite will now last until you die and can spread.
	* [CHANGE] Global toolmode deny doesn't affect admins.

v3.02 - *(01/10/07)*
	* [CHANGE] Admin menu won't spam console so bad now
	* [FIX] Some more command crossbreeding issues (IE ragdolling jailed player)
	* [FIX] Teleport commands able to put someone in a wall. This is still possible, but much less likely.
	* [ADD] Motd manipulation. Auto-shows on startup and !motd
	* [ADD] toolallow, tooldeny, tooluserallow, tooluserdeny. Works fine, but is EXPERIMENTAL!

v3.01 - *(01/07/07)*
	* [ADD] ulx whip
	* [ADD] ulx adduser
	* [ADD] ulx userallow - Allow users access to commands
	* [ADD] ulx userdeny - Deny users access to commands
	* [ADD] ulx bring - Bring a user to you
	* [ADD] ulx goto - Goto a user
	* [ADD] ulx teleport - Teleport to where you're looking
	* [ADD] IRC-style "/me" command
	* [FIX] You can't use the adminmenu outside sandbox now
	* [FIX] Vastly improved "ulx jail"
	* [FIX] Improved "ulx ragdoll"
	* [FIX] pvp damage checkbox in adminmenu not working.
	* [FIX] Ban button
	* [FIX] Ban not kicking users
	* [FIX] Blinded users being able to see through the camera tool
	* [FIX] Admin menu not showing values on a dedicated server
	* [FIX] Admin menu checkboxes (which are now buttons!)
	* [FIX] Ulx commands much more usable from dedicated server console.
	* [FIX] Dedicated server spam (IsListenServerHost)
	* [FIX] Uncloak works properly now
	* [FIX] Various problems using commands on users in vehicles. (Thanks Jalit)

v3.0  - *(01/01/07)* 
	* Initial version for GM10

Group: Credits

Thanks to everyone in #ulysses in irc.gamesurge.net for not giving up on me :)
A big thanks to JamminR for listening to me ramble on and for giving the project fresh insights.

Group: License

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License. 
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to 
Creative Commons
543 Howard Street
5th Floor
San Francisco, California 94105
USA