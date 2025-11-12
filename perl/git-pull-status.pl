#!/usr/bin/env perl

use strict;
use warnings;
use File::Basename;
use POSIX qw(strftime);

# Print script name with timestamp
my $script_name = basename($0);
my $timestamp = strftime("%a %b %d %H:%M:%S %Z %Y", localtime);
print "\033[1m$timestamp$ script_name\033[0m\n";

# Initialize counters and timing
my $counter = 0;
my $subcounter = 0;
my $start_time = time();

sub new_step {
    my ($message) = @_;
    $counter++;
    $subcounter = 0;
    print "\nStep $counter: $message\n";
}

sub sub_step {
    my ($message) = @_;
    $subcounter++;
    print "\n  Substep $counter.$ subcounter: $message\n";
}

sub display_total_elapsed_time {
    my $total_elapsed = time() -$ start_time;
    my $minutes = int($ total_elapsed / 60);
    my $seconds =$ total_elapsed % 60;
    print "\nTotal elapsed time: " . sprintf("%02d:%02d", $minutes,$ seconds) . " (MM:SS)\n";
}

# Main script begins
new_step("Sweep through directories for Git operations");

opendir(my $dh, '.') or die "Cannot open current directory: $!";
my @dirs = grep { -d $_ && $_ !~ /^\.\.?$/ } readdir($ dh);
closedir($dh);

my $repo_count = 0;
my $start_dir = `pwd`;
chomp($start_dir);

foreach my $dir (@dirs) {
    if (-d "$dir/.git") {
        $repo_count++;
        sub_step("Processing repository: $dir");
        
        chdir($dir) or die "Cannot chdir to $dir: $!";
        
        print "\n    --- Git Pull ---\n";
        system("git pull");
        
        print "\n    --- Git Status ---\n";
        system("git status");
        
        print "\n";
        
        chdir($start_dir) or die "Cannot return to start directory: $!";
    }
}

new_step("Summary");
print "  Processed $repo_count git repositories\n";

display_total_elapsed_time();
