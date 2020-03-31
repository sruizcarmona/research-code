#!/usr/bin/perl
#
        $NAME=HUP;
        @elem=( " X"," H","He","Li","Be"," B"," C"," N",
		" O"," F","Ne","Na","Mg","Al","Si","Be",
		" S","Cl","Ar"," K","Ca","Sc","Ti","V","Cr",
		"Mn","Fe","Co","Ni","Cu","Zn","Ga","Ge","As","Se",
		"Br","Kr","Rb","Sr"," Y","Zr","Nb","Mo","Tc","Ru",
		"Rh","Pd","Ag","Cd","In","Sn","Sb","Te"," I","Xe");
        @rad=(0.00,1.10,0.00,0.00,0.00,0.00,1.55,1.40,
              1.35,0.00,0.00,0.00,0.00,0.00,0.00,0.00,
              1.81,1.75,0.00,0.00,0.00,0.00,0.00,0.00,
		0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00);

	$out = 0;
	if (defined $ARGV[1] && $ARGV[1] eq 'XYZ') {$out = 1}
	$ngeo=0;
	open(F0,"$ARGV[0]") || die "Cannot open file: $!";
        while (<F0>) {

#Count the number of times the standard orientation is printed out (just in case it's a non-vonverged run)
		if (/Standard orientation/) {$ngeo++}

		if (/Stationary point found/) {
			$optok = 1;
			next;
		}
		if ($optok == 1) {
			if (/Input orientation/ || /Z-Matrix orientation/) {
				$read = 1;
				while ($read == 1) {
					$line = <F0>;
					chomp ($line = $line);
					@word = split(' ',$line);
					if ($word[0] =~ /[0-9]/) {
						push (@GEO_INP,$word[1],$word[3],$word[4],$word[5]);
					}elsif (defined @GEO_INP) {
						$read = 0;
					}
				}
			}
			if (/Standard orientation/) {
				$read = 1;
				while ($read == 1) {
					$line = <F0>;
					chomp ($line = $line);
					@word = split(' ',$line);
					if ($word[0] =~ /[0-9]/) {
						push (@GEO_STD,$word[1],$word[3],$word[4],$word[5]);
					}elsif (defined @GEO_STD) {
						$read = 0;
					}
				}
			}
			if (defined @GEO_STD && defined @GEO_INP) {last;}
		}
	}
	close (F0);

	$ngeo2=0;
	if ($optok != 1) {
	   open(F0,"$ARGV[0]") || die "Cannot open file: $!";
	   while (<F0>) {
		if (/Standard orientation/) {$ngeo2++}
		if ($ngeo == $ngeo2) {
			$read = 1;
			while ($read == 1) {
				$line = <F0>;
				chomp ($line = $line);
				@word = split(' ',$line);
				if ($word[0] =~ /[0-9]/) {
					push (@GEO_STD,$word[1],$word[3],$word[4],$word[5]);
				}elsif (defined @GEO_STD) {
					$read = 0;
				}
			}
			last;
		}
	   }
	   close (F0);
	}

	if (defined @GEO_INP) {
		printf STDERR "Output is successful optimization in Input Orientation\n";
		@GEO_STD = @GEO_INP;
	}elsif (defined @GEO_STD && $optok == 1) {
		printf STDERR "Output is successful optimization in Standard Orientation\n";
	}elsif (defined @GEO_STD && $optok != 1) {
		printf STDERR "Optimization did NOT converge. Output is last  Standard Orientation found\n";
	}else{
		printf STDERR "Something went wrong. Should not be here!\n";
		exit;
	}
		
	$nu = 0;
        $zero=0;
        $one=1;
	while (@GEO_STD) {
		$nu++;
		$k = shift(@GEO_STD);
		$x = shift(@GEO_STD);
		$y = shift(@GEO_STD);
		$z = shift(@GEO_STD);
		if ($out == 0) {
         		printf "ATOM%7.0f%3s%6s%6.0f%12.3f%8.3f%8.3f%6.2f%7.3f\n",
			   $nu,$elem[$k],$NAME,$one,$x,$y,$z,$one,$zero;
		}else{
         		printf " %3s%16.5f%16.5f%16.5f\n",$elem[$k],$x,$y,$z;
		}
	}
