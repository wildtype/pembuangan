#!/usr/bin/env perl

# kopitengah: Wildtype, 2013
# referensi: http://search.cpan.org/~askadna/WebService-Dropbox-0.03/lib/WebService/Dropbox.pm

use strict;
use warnings;
use WebService::Dropbox;
use IO::File;
#use Data::Dumper;


if ( $#ARGV < 0 ) {
  die "Masukin argumen nama file!\n";
}

my $dropbox = WebService::Dropbox->new ({
    key => '',
    secret => '',
    root => 'sandbox'
});


my $access_token = ""; # diisi setelah dapat ijin
my $access_secret = ""; # idem


if ( !$access_token or !$access_secret ) {

    my $uri = $dropbox->login or die $dropbox->error;
    print "buka url enih, terus enter: $uri";
    <STDIN>;

    $dropbox->auth or die $dropbox->error;
    print "access_token: " . $dropbox->access_token;
    print "access_secret: " . $dropbox->access_secret;

} else {
    
    $dropbox->access_token($access_token);
    $dropbox->access_secret($access_secret);

}

# testing, apakah auth berhasil?
# my $info = $dropbox->account_info or die $dropbox->error;
# print "info: " . Dumper($info);

# eksyen mulai disinih
foreach ( @ARGV ) {

  my $nama_file = $_;
  my $file = IO::File->new($nama_file,'r');

  if ( defined $file ) {
      
      print "Mengupload $nama_file, ";
      $dropbox->files_put($nama_file,$file) or die $dropbox->error;
      $file->close;
      print "menghapus $nama_file\n";
      unlink ( $nama_file );
  
  }

}

