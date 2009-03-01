#!/usr/bin/perl

use strict;
use XML::FeedPP;
chdir '/home/awwaiid/tlt/darcs-git';

my %github = (
  'perl-Continuity' => 1,
  'perl-EPFarms-Panel' => 1,
  'perl-WWW-HtmlUnit' => 1,
  'perl-Continuity-Monitor' => 1,
  'javascript-autoindent', => 1,
);

my @darcs_dirs = `find /home/awwaiid/projects/ -name '_darcs'`;
@darcs_dirs = map { chomp; s/\/_darcs$// ; tr/'//; $_ } @darcs_dirs;

my @projects = map {
    my $path = $_;
    s/\/home\/awwaiid\/projects\///;
    my $url = $_;
    s/\//-/g;
    { path => $path, name => $_, url => $url}
  } @darcs_dirs;

my $all_feed = XML::FeedPP::RSS->new();
my @all_items;

foreach my $project (@projects) {
  print "Processing $project->{name}\n";
  unless(-e $project->{name}) {
    mkdir($project->{name});
  }
  chdir $project->{name};
  `../darcs-to-git '$project->{path}'`;

  # If this is in the list, push it to github
  if($github{$project->{name}}) {
    `git push github master`;
  }
  chdir '..';
}


