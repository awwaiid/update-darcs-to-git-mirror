#!/usr/bin/perl

use strict;
chdir '/home/awwaiid/tlt/darcs-git';

# To add another, for example "darcs_git" first add it to github, which will
# give you the remote add command. Switch "origin" to "github"... then do:
#
#   cd perl-darcs_git
#   git remote add github git@github.com:awwaiid/update-darcs-to-git-mirror.git
#
# and then add it to the list below!

# Hard-wired list of things mirrored on github
my %github = (
  'perl-Continuity' => 1,
  'perl-EPFarms-Panel' => 1,
  'perl-WWW-HtmlUnit' => 1,
  'perl-Continuity-Monitor' => 1,
  'javascript-autoindent', => 1,
  'perl-darcs_git' => 1,
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


