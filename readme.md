Gitolite config file generator from MySql
=========================================

After some googling I came to the conclusion that there are no mysql backends for any git authentication system. 
Since writing a backend could take some time, I've created this generator. It simply generates the gitolite config file based on the information in the database.

It currently loads repositories, users, permissions and keys from MySQL using custom queries, but not groups yet (because I don't personally use them). It writes the repository config to the specified config file (for example conf/mysql.conf) and the user keys to the keys directory (keydir/) in the gitolite-admin repository.

Features
--------
 * Load repositories, users, permissions and keys from MySql.
 * Custom queries.
 * Checkout, edit, commit and push the gitolite-admin repository automatically.

Contact
-------
Feel free to send pull requests :)
