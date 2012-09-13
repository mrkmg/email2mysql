email2mysql
===========

A script that takes an email from STDIN (for example from a pipe) and inserts into a MySQL database.

Usage
=====

To use this script, first replace the following items in the script:

- _\_DATABASE__ The name of the Schema/Database
- _\_SERVER__ The host of the MySQL Server. ex: localhost, 192.168.0.10, etc
- _\_USER__ The user of the MySQL database
- _\_PASSWORD __ The password of the MySQL user

Place the script on your server and make sure it is accessible and executable by your MTA. Set your MTA to pipe incoming emails to this script. That should be all that is needed.

Requirements
============

You must have perl installed and the following modules installed:

- DBI
- Email::MIME
- Email::Address
- HTML::Strip
