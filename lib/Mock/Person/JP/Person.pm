package Mock::Person::JP::Person;

use strict;
use warnings;
use Mock::Person::JP::Person::Name ();

sub new
{
    my ($class, $arg) = @_;

    my $self = bless $arg, $class;
    $self->{name} = $self->_rand_name;

    return $self;
}

sub name { Mock::Person::JP::Person::Name->new(shift->{name}); }

sub _rand_name
{
    my ($self) = @_;

    my $sei = $self->{sei}->next;
    my $mei = $self->{mei}->next;

    # Faster than Encode::decode_utf8
    utf8::decode($sei);
    utf8::decode($mei);

    my %name;
    ($name{sei_yomi}, $name{sei}) = split(/\t/, $sei);
    ($name{mei_yomi}, $name{mei}) = split(/\t/, $mei);

    return \%name;
}

1;

__END__

=encoding utf-8

=head1 NAME

Mock::Person::JP::Person - Get personal information

=head1 SYNOPSIS

See L<Mock::Person::JP>.

=head1 METHODS

=head2 name()

Returns a new L<Mock::Person::JP::Person::Name> instance.
