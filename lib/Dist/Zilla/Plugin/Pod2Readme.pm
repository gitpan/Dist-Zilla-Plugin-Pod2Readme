use 5.008;
use strict;
use warnings;

package Dist::Zilla::Plugin::Pod2Readme;
# ABSTRACT: Generate README from Pod, as simply as possible

our $VERSION = '0.001';

use Dist::Zilla 5 ();

use Moose;
with 'Dist::Zilla::Role::FileGatherer';

#pod =attr filename
#pod
#pod Name for the generated README.  Defaults to 'README'.
#pod
#pod =cut

has filename => (
    is      => 'ro',
    isa     => 'Str',
    default => 'README'
);

sub gather_files {
    my $self = shift;

    require Dist::Zilla::File::FromCode;
    require Pod::Text;

    $self->add_file(
        Dist::Zilla::File::FromCode->new(
            {
                name => $self->filename,
                code => sub {
                    my $parser = Pod::Text->new();
                    $parser->output_string( \( my $text ) );
                    my $pod = $self->zilla->main_module->content;
                    $parser->parse_string_document($pod);
                    return $text;
                },
            }
        )
    );

    return;
}

1;


# vim: ts=4 sts=4 sw=4 et tw=75:

__END__

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::Plugin::Pod2Readme - Generate README from Pod, as simply as possible

=head1 VERSION

version 0.001

=head1 SYNOPSIS

    # in dist.ini
    [Pod2Readme]

=head1 DESCRIPTION

This module generates a text F<README> file from the POD of your
main module.

=head1 ATTRIBUTES

=head2 filename

Name for the generated README.  Defaults to 'README'.

=for Pod::Coverage gather_files

=head1 SEE ALSO

=over 4

=item *

L<Dist::Zilla::Plugin::Readme> - bare bones boilerplate README

=item *

L<Dist::Zilla::Plugin::ReadmeFromPod> - overly complex version of this

=item *

L<Dist::Zilla::Plugin::ReadmeAnyFromPod> - overly complex, but does multiple file types

=back

=for :stopwords cpan testmatrix url annocpan anno bugtracker rt cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 SUPPORT

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at L<https://github.com/dagolden/Dist-Zilla-Plugin-Pod2Readme/issues>.
You will be notified automatically of any progress on your issue.

=head2 Source Code

This is open source software.  The code repository is available for
public review and contribution under the terms of the license.

L<https://github.com/dagolden/Dist-Zilla-Plugin-Pod2Readme>

  git clone https://github.com/dagolden/Dist-Zilla-Plugin-Pod2Readme.git

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut
