require 5.000;
use ExtUtils::MakeMaker;
WriteMakefile(
	'NAME'         => 'Inline::FileSystem',
	'VERSION_FROM' => 'lib/Inline/FileSystem.pm',
	'PREREQ_PM'    => {
		# Needed by Perl::SAX
		'File::Spec'       => '0.82',
		'Class::Default'   => '1.0',
		'MIME::Base64'     => '3.00',
		'IO::Scalar'       => '2.105',

		# Needed by tests
		'Test::More'       => '0.47',
		},

	($] >= 5.005) ? (
		'AUTHOR'   => 'Adam Kennedy (cpan@ali.as)',
		'ABSTRACT' => 'Bundle an entire mini-filesystem inside your module',
	) : (),
);
