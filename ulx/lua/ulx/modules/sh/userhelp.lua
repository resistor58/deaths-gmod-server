local help = [[


General User Management Concepts:
User access is driven by ULib's Ulysses Control List (UCL). This list contains users and groups,
both have allow and deny lists. The allow and deny lists contain access strings like "ulx slap" or
"ulx phygunplayer" to show what a user and/or group does and does not have access to. If a user has
"ulx slap" in their user allow list or in the allow list of one of the groups they belong to, they
have access to slap. If a user has "ulx slap" in their user DENY list or in the deny list of one of
the groups they belong to, they are DENIED the command, even if they have the command in one of
their allow lists. In this way, deny takes precedence over allow.

You cannot modify the superadmin group or any superadmin users from a client that isn't the listen
server host. This is a built in safety feature to ensure that their are no attempts at takeovers.
You can, however, modify the group and users from a listen server host or a dedicated console.

ULib supports admin immunity. This makes it so lower admins cannot target users with immunity. (IE,
peons can't kick the superadmin) However, some admins can overcome immunity (by default, all
superadmins can do this). In this way, superadmin can still kick peons with immunity.


More Advanced Concepts:
"immunity" is the access string used for immunity, "overcomeimmunity" is the access string used for
overcoming immunity. By default, superadmins have access to "overcomeimmunity".

Groups have inheritance. You can specify what group they inherit from in the addgroup command. If a
user is in a group that has inheritance, UCL will check all groups connected in the inheritance
chain. But, please note that it only checks for ALLOWS in the inherited groups and ignores DENIES.

If you want to add a user to more than one group or add more than one group into another group's
inheritance, you'll need to modify the garrysmod/data/ULib/groups.txt and/or data/ULib/users.txt
file(s) by hand; these commands do not support doing that.


User Management Commands:
ulx adduser <user> <group> [<immunity>] - Add the specified CONNECTED player to the specified group
  with or without immunity. This command will give the user PERMANENT access, so please be careful!
The group MUST exist for this command to succeed. Use operator, admin, superadmin, or see ulx
addgroup. You can only specify one group. See above for explanation on immunity.
Ex 1. ulx adduser "Someguy" superadmin 1  -- This will add the user "Someguy" to the group
  superadmin with immunity
Ex 2. ulx adduser "Dood" monkey           -- This will add the user "Dood" to the group monkey
  without immunity, on the condition that the group exists

ulx removeuser <user> - Remove the specified CONNECTED player from the permanent access list.
Ex 1. ulx removeuser "Foo bar"            -- This removes the user "Foo bar" forever

ulx userallow <user> <access> [<revoke>] - Puts (or removes) the access on the USER'S ALLOW list.
  If revoke is "1", it removes.
See above for explanation of allow list vs. deny list, as well as how access strings work.
Ex 1. ulx userallow "Pi" "ulx slap"       -- This grants the user "Pi" access to "ulx slap"
Ex 1. ulx userallow "Pi" "ulx slap" 1     -- This revokes user "Pi"'s access to "ulx slap"

ulx userdeny <user> <access> [<revoke>] - Puts (or removes) the access on the USER'S DENY list.
  If revoke is "1", it removes.
See above for explanation of allow list vs. deny list, as well as how access strings work.
Ex 1. ulx userdeny "Bob" "ulx slap"       -- This restricts the user "Pi" access to "ulx slap"
Ex 1. ulx userdeny "Bob" "ulx slap" 1     -- This revokes the user "Pi"'s restriction to "ulx slap"
  (but they won't necessarily have access to it)

ulx addgroup <group> [<inherit_from>] - Creates a group, optionally inheriting from the specified
  group. See above for explanation on inheritance.

ulx removegroup <group> - Removes a group PERMANENTLY. Also removes the group from all connected
  users and all users who connect in the future. If a user has no group besides this, they will
  become guests. Please be VERY careful with this command!

ulx groupallow <group> <access> [<revoke>] - Puts (or removes) the access on the GROUP'S ALLOW
  list. If revoke is "1", it removes. See above for explanation of allow list vs. deny list, as
  well as how access strings work.

ulx groupdeny <group> <access> [<revoke>] - Puts (or removes) the access on the GROUP'S DENY list.
  If revoke is "1", it removes. See above for explanation of allow list vs. deny list, as well as
  how access strings work.


]]

function ulx.showUserHelp( um )
	local lines = ULib.explode( "\n", help )
	for _, line in ipairs( lines ) do
		Msg( line .. "\n" )
	end
end
usermessage.Hook( "ULXUserManagementHelp", ulx.showUserHelp )