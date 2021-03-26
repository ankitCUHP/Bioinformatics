#!/usr/bin/perl

# ### this program was written by Dr. Mahesh Kulharia to divide the multiple ligand containing mol2 files into individual files. This was expected to increase the dock speed.


if($ARGV[0] ne ''){
$infilename = $ARGV[0];                                               #FILE containing DATABASE of ligands in MOL2 format.
}else{print "enter the list file name ";   
$infilename = <STDIN>;   
}
print "$infilename";

chomp ($infilename);

open(INFILE, "$infilename") ||	print STDERR "ERROR: Can't open $infilename\n";

my @infile = <INFILE>;

close(INFILE);

my $lastindex = scalar @infile;
my $d = 0;
my @index = ();
my @moleculenames = ();

for(my $c = 0; $c < $#infile; $c++)
{
	chomp($infile[$c]);
	chomp($infile[$c+1]);
	if($infile[$c] =~ /^\@\<TRIPOS\>MOLECULE/)
	{
		#print "$infile[$c]\n";
		$d++;
		$index[$d] = $c;
		$moleculenames[$d] = $infile[$c+1];
		print "\n$moleculenames[$d]\t$index[$d]";
	}
	else
	{
		next;
	}

}

my $moleculenumber = scalar @index;
chomp($lastindex);
$index[$moleculenumber] = $lastindex;

@index = sort {$a <=> $b} @index;

for(my $c = 0; $c <= $#index; $c++)
{
	my $moleculesize = $index[$c+1] - $index[$c];
	print "$index[$c] \t $moleculenames[$c]\n";
	open(OUT, ">>dec\_$moleculenames[$c]\.mol2");
	
	for(my $d = 0; $d < $moleculesize; $d++)
	{
		my $linenumber = $index[$c] + $d;
		print OUT "$infile[$linenumber]\n";
	}

}

exit;
