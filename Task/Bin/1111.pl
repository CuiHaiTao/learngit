$data = "sp|O15020-2|SPTN2_HUMAN";
print $1 if $data =~ m/([^|]+)_/;
