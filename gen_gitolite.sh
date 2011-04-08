#!/usr/bin/php -f
<?php

// database info
$user= 'git';
$pass= 'bhu8nji9';
$db= 'lich_users';
$host= 'localhost';

// use a different group instead of default @all ?
$all_group = "@all";

// Get the names of all active repositories, and ids for later getting the permissions
$query_repos = "SELECT repository_id AS id, name, default_permission FROM git_repositories WHERE status = 1";
// Get all users and their gitolite permissions for a specific repo (in RW+ etc form)
$query_permissions = "SELECT u.username, gp.permissions FROM git_permissions gp, users u WHERE u.id = gp.user_id AND u.status = 1 AND gp.repository_id = ";
// Get the public keys of all git enabled users
$query_keys = "SELECT u.username, uk.key FROM users u, user_keys uk, groups g, user2group ug WHERE g.groupname = 'git' AND ug.group_id = g.group_id AND u.id = uk.user_id AND ug.user_id = u.id";


// commandline options
if(count($_SERVER['argv']) != 4)
{
	die("Required commandline parameters: <gitolite-admin url> <file.conf> <keydir> \n");
}

$admin_url = $_SERVER['argv'][1];
$config_file = $_SERVER['argv'][2];
$key_dir = $_SERVER['argv'][3];

// checkout the gitolite admin repository
chdir("/tmp");
exec("git clone $admin_url");

$result_config = '';
$conn = mysql_connect($host, $user, $pass);
mysql_select_db($db);

// Find the repositories
$repos = mysql_query($query_repos);

if(!$repos) die(mysql_error() . "\n");

while($repo = mysql_fetch_assoc($repos))
{
	// Create the repository definition
	$result_config .= "repo " . $repo['name'] . "\n";
	// set the custom @all group to this permission
	$result_config .= $repo['default_permission'] . " = $all_group\n";
	
	// find the rest of the permissions (users only!)
	$permissions = mysql_query($query_permissions . $repo['id']);

	if(!$permissions) die(mysql_error() . "\n");
	
	while($permission = mysql_fetch_assoc($permissions))
	{
		$result_config .= $permission['permissions'] . " = " . $permission['username'] . "\n";
	}
}


// Go to the repos and write the result config to $config_file
chdir("gitolite-admin");
echo $result_config;

file_put_contents($config_file, $result_config);

// Write the keys for all git-enabled users
$keys = mysql_query($query_keys);

if(!$keys) die(mysql_error() . "\n");

//echo getcwd();

while($key = mysql_fetch_assoc($keys))
{
	$keyfile = $key_dir . $key['username'] . '.pub';
	if(!file_exists($keyfile)) exec('touch ' . $keyfile);
	file_put_contents($keyfile, $key['key']);
}


exec("git add $key_dir && git add $config_file && git commit -am 'automated generation from mysql' && git push");
chdir("/tmp");
exec("rm -rf gitolite-admin");






?>
