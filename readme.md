Gitolite config file generator from MySql
=========================================

After some googling I came to the conclusion that there are no mysql backends for any git authentication system. 
Since writing a backend could take some time, I've created this generator.

It currently loads repositories, users, permissions and keys from MySQL using custom queries, but not groups yet (because I don't personally use them).

Features
--------
 * Load repositories, users, permissions and keys from MySql.
 * Custom queries.
 * Checkout, edit, commit and push the gitolite-admin repository.

Contact
-------
Feel free to send pull requests :)
