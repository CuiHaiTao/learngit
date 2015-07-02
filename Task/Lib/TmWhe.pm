package TmWhe;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(DealTmWheFile);


use warnings;
use strict;
use File::Find;
use Cwd;

my $datapath;
my $jarpath;
my $modelpath;
sub wanted 
{
		if ($_ =~ /^data$/i and -d $_)
		{
			$datapath = $File::Find::name;
			#print $datapath."DDDD\n\n";
		}
		if ($_ =~ /^jar$/i and -d $_)
		{
			$jarpath = $File::Find::name;
		}
		if ($_ =~ /^model/i and -d $_)
		{
			$modelpath = $File::Find::name;
		}
}

sub DealTmWheFile
{
	my $text_path = shift;
	#print $text_path."\n";
	my $file_handle;
	my $TmWhe_handle;
	my $dirpath = getcwd();
	my $count_sprit;

	my ($dirname, $outName) = $dirpath =~ /(.*)\/(.*)/;
	my @count = $dirpath =~ /\//g;
	if(scalar(@count) <= 1.1)
	{
		finddepth(\&wanted,"$dirpath");
	}
	else
	{
		finddepth(\&wanted,"$dirname");
	}
	#print $text_path;
	open($file_handle,"< $text_path") || die "can not open  can not open $text_path \n";
	# while(<$file_handle>)
	# {
		# chomp;
		# s/\<DATE\>.*?\>/time/g;
		
	# }
	if(-d $datapath)
	{
		open($TmWhe_handle,"> $datapath/text.ner") || die "can not create this file \n";
		print $TmWhe_handle `java -cp $jarpath/stanford-ner-3.5.2.jar edu.stanford.nlp.ie.crf.CRFClassifier -loadClassifier $modelpath/english.muc.7class.distsim.crf.ser.gz -textFile $text_path -outputFormat inlineXML`;
		close($TmWhe_handle);
		open($TmWhe_handle,"< $datapath/text.ner") || die "can not open this file XXX\n";
		my $tmphandle;
		open($tmphandle,"> $datapath/text.TmWhe") || die "can not create this file \n";
		while(<$TmWhe_handle>)
		{
		 chomp;
		 s/\<DATE\>.*?\>/TIME/g;
		 s/\<LOCATION\>.*?\>/PLACE/g;
		 s/\<[A-Z]+\>//g;
		 s/\<\/[A-Z]+\>//g;
		 print $tmphandle "$_\n";
		 #print"\n";
		}
		close($TmWhe_handle);
		close($tmphandle);
		my ($outpath) = "$datapath/text.TmWhe";
		# print"DDDD\n";
		# print $outpath;
		# print"DDDD\n";
		#$outpath
		return $outpath;
	}
	else
	{
		print "not exist this directory \n";
	}
	

}

# sub TmWhe_Sentence
# {
	# return @NerArr;
# }

return 1;


