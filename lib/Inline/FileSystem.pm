package Inline::FileSystem;

# See POD at end of file for docs.

# Suggested Implementation Guidelines
# -----------------------------------
#
# Just follow the docs, they are fairly detailed.
# In general though, try to stick to pure-perl. This module is quite useful
# as something to include with apps, so if all it's dependencies are
# pure perl, so much the better.
#
# The Bits You Will Need
# ----------------------
#
# (These have already been added to the makefile)
#
# * Class::Default has the static -> default object functionality
#
# * MIME::Base64 has the decoding logic
#
# * IO::Scalar can hold the decoded data and present it as an IO::Handle
#
# * File::Spec for converting to local paths and checking file name rules

use strict;
use UNIVERSAL 'isa';

use vars qw{$VERSION};
BEGIN {
	$VERSION = '0.00_01';
}

1;

__END__

=pod

=head1 NAME

Inline::FileSystem - Bundle a mini-filesystem inside a script/module

=head1 STATUS

This module exists only as a statement of intent. The implementation
has not yet been written.

=head1 DESCRIPTION

Inline::FileSystem provides a mechanism to bundle an entire nested
filesystem inside a script or module. It is similar in concept to the
more general L<Inline::File|Inline::File> concept, except that while
Inline::File provides a general mechanism for reading and writing to
filehandles stored at the end of a file, Inline::FileSystem is designed
primarily for "bundling" files into a module that are not going to be
modified.

Thus by default Inline::FileSystem is read-only. This ensures that the
end user of a module is protected, and cannot break the modules either
intentionally or unintentionally. To make sure this is so, the base
Inline::FileSystem module does not even contain any code that could allow
it to change the files. That requires the installation of an additional
package, L<Inline::FileSystem::Writer|Inline::FileSystem::Writer>.

Typically, a package author will write the filesystem to the file at
the time the package is being written, so that the attached files are in
place before the module has even been packaged.

=head1 FILE FORMAT

A typical file containin an Inline::FileSystem will look something like
the following.

  package Foo::Bar;
  
  # Your normal file content here
  
  1;
  
  __DATA__
  Inline::FileSystem 0.01
  
  README.txt
  BASE64DATA
  BASE64DATA
  ETC
  
  my/file.txt
  BASE64DATA
  BASE64DATA
  ETC
  
  my/gifs/logo.gif
  BASE64DATA
  BASE64DATA
  ETC

=head2 File-System Header

The first line MUST contain "Inline::FileSystem" followed by the version
that the data was written for. In general, the major version number indicates
an incompatible format change. That is, any Inline::FileSystem module can
safely read files up to X.999, where X is the major version number of the
Inline::FileSystem version that is attempting to read the file.

=head2 File Seperator

A new file is indicated by one or more blank lines.

=head2 File Header

A file header consists of the full name of the file, in Unix format. The
file name should also ALWAYS be listed in relative form. That is, it should
not start with /. Additionally, the filename should not contain any
C<curdir> or C<updir> elements.

=head2 Base64 Content

Immediately following the file name is an arbitrary number of lines
containing Base64-encoded data. Please note that for simplicity purposes
ALL files are encoded as binary files in Base64 form, whether they are
actually binary or not.

The file contents ends at the next empty line.

=head2 End of File

There should always be a File Seperator at the end of the
Inline::FileSystem data. That is, there should be one or more newlines,
and the file should not just end while in Base64 data.

=head1 METHODS

=head2 new [ $class | $filename ]

The C<new> constructor creates a new Inline::FileSystem object. If not
passed any arguments it creates a new Inline::FileSystem object for the
file in which C<new> is called.

This default constructor is also used if any of the instance methods below
are used in a static form.

  # ->files is an instance method.
  
  # Using it like this...
  my @files = Inline::FileSystem->files;
  
  # ...is equivalent to this
  my @files = Inline::FileSystem->new->files;

If passed a file name, C<new> will search for an Inline::FileSystem defined
in it. If passed something that looks like a module name, it will first check
for an actual file of that name, and then search @INC to find the loaded
module.

Returns a new Inline::FileSystem object, or C<undef> if the file does not
exists, does not have an Inline::FileSystem, or if the module is unable to
load the Inline::FileSystem (due to version compatibility issues defined
earlier)

=head2 files

When called in list context, the C<files> method returns a list of all the
files in the Inline::FileSystem. The order of the files is the same as the
order in which the files are defined in the Inline::FileSystem.

When called in scalar context, the C<files> method returns the number of
files defined in the Inline::FileSystem.

Because the Inline::FileSystem should have been fully testing before it was
installed, the C<files> method will die on error.

=head2 exists $path

Given a file name, the C<exists> method will check for the existance of the
file.

Returns true if the file exists in the Inline::FileSystem, false if not, or
die on error.

=head2 open $path

  DOCUMENTATION INCOMPLETE

=head1 TO DO

Write the actual module.

Write Inline::FileSystem::Writer to generate the file lists

=head1 SUPPORT

There are no bugs, there's nothing to be broken, but for future reference:

L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Inline%3A%3AFileSystem>

For other issues, contact the designer

=head1 AUTHORS

Adam Kennedy (Concept/Design), L<http://ali.as/>, cpan@ali.as

B<(Your Name Here)>

=head1 COPYRIGHT

B<(Your Name Here)>

Copyright (c) 2003-2004 Adam Kennedy. All rights reserved.
This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut
