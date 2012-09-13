#!/usr/bin/perl
# Created/Modified by Kevin Gravier <MrKMG> http:mrkmg.com
# 
# This script takes an email (Piped in from STDIN) and inserts it as  
# plaintext into a MySQL Database. Released with the MIT License.
#
#
# Original ---- http://www.blazonry.com/perl/mail2mysql.php -------
# blazonry.com
# Created On: Thu Dec 28, 2000 10:35:03
# Last Updated: Wed Jan 03, 2001 12:44:30
# ------------------------------------------------------------------
#
# My MySQL database was created using 
# the following SQL statement:
#
# CREATE TABLE imported_emails (
#    id          INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
#    sender      VARCHAR(128),
#    subject     VARCHAR(128),
#    description TEXT,
#    ts_date     TIMESTAMP,
#    PRIMARY KEY(id)
# );

#OTHER REQUIREMENTS:
use Email::MIME;
use Email::Address;
use DBI;
use HTML::Strip;
#-- CONFIGURE to match your database settings
my $dsn = "DBI:mysql:_DATABASE_:_SERVER_";
my $user = "_USER_";
my $pass = "_PASSWORD_";

#-- No need to edit anything below this point unless you want to edit how the script
#-- works. Forexample you could remove the html2text if you want to include the html
#-- in the database. 
sub handle_parts {
    my $part = shift;
    my $content_type = $part->content_type;
    my $body = $part->body;
    if ($content_type =~ m#text/plain#) {
        return $body;
    } elsif ($content_type =~ m#text/html#) {
        return html2text($body);
    } elsif ($content_type =~ m#multipart/#) {
        for my $subpart ($part->parts) {
            my $text = handle_parts($subpart);
            return $text if defined $text;
        }
    }
    return;
}
sub html2text {
    my $hs = HTML::Strip->new();
    my $html = shift;
    my $text = $hs->parse($html);
    return $text;
}
$db = DBI->connect($dsn, $user, $pass);
my $email = Email::MIME->new(join('', <STDIN>));
my $msg = handle_parts($email);
my $fromorg = $email->header("From");
my @fromobjs = Email::Address->parse($fromorg);
my $from=  lc($fromobjs[0]->address);
my $subject= $email->header("Subject");
$sql = " INSERT INTO imported_emails ";
$sql = $sql . " (sender, subject, description) VALUES (?, ?, ?)";
my $dbh = $db->prepare($sql);
$dbh->execute($from,$subject,$msg);
$db->disconnect;
