#!/usr/bin/env perl
use v5.14;

use Benchmark qw(timeit timestr);

sub stuff {
	my $start;
	my @flights;

	while (<>) {
		chomp;
		unless ($start) {
			$start = $_;
			next;
		}

		my ($from, $to, $day, $price) = split /\s+/;
		push @flights, {from => $from, to => $to, day => $day, price => $price};
	}

	say($start);
	say(scalar @flights);
}

say(timestr(timeit(1, 'stuff')));
