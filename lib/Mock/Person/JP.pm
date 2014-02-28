package Mock::Person::JP;

use 5.008_001;
use strict;
use warnings;
use Carp ();
use File::ShareDir   ();
use File::RandomLine ();
use Mock::Person::JP::Person ();

our $VERSION = "0.02";

sub new
{
    my ($class) = @_;

    my $self = bless {}, $class;

    $self->{sei}         = File::RandomLine->new( File::ShareDir::dist_file('Mock-Person-JP', 'sei.tsv') );
    $self->{mei}{female} = File::RandomLine->new( File::ShareDir::dist_file('Mock-Person-JP', 'mei_female.tsv') );

    return $self;
}

sub create_person
{
    my $self = shift;

    my %arg = (ref $_[0] eq 'HASH') ? %{$_[0]} : @_;

    Carp::croak('sex option required') unless exists $arg{sex};

    for my $key (keys %arg)
    {
        if ($key eq 'sex')
        {
            Carp::croak("sex option must be 'male' or 'female'") if $arg{$key} ne 'male' && $arg{$key} ne 'female';
            Carp::croak("'male' option not implemented yet!")    if $arg{$key} eq 'male';
        }
        else { Carp::croak "Unknown option: '$key'";  }
    }

    $arg{name} = $self->_rand_name($arg{sex});

    return Mock::Person::JP::Person->new(\%arg);
}

sub _rand_name
{
    my ($self, $sex) = @_;

    my $sei = $self->{sei}->next;
    my $mei = $self->{mei}{$sex}->next;

    # Faster than Encode::decode_utf8 and no need to validate the string
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

=for stopwords ume20＠dd.iij4u.or.jp mecab-ipadic yomi

=head1 NAME

Mock::Person::JP - Generate random sets of Japanese names

=head1 SYNOPSIS

    use Mock::Person::JP;

    my $mpj = Mock::Person::JP->new;

    for (1 .. 10)
    {
        my $name = $mpj->create_person(sex => 'female')->name;
        printf("%s %s（%s %s）\n", $name->sei, $name->mei, $name->sei_yomi, $name->mei_yomi);
    }

    # Sample output:
    # 小合 希砂妃（おごう きさき）
    # 井園 みのる（いその みのる）
    # 村山 菜奈世（むらやま ななよ）
    # 尾間 勇凪（おま いさな）
    # 水出 ソラ（みずいで そら）
    # 草間 未佑（くさま みゆ）
    # 高先 茶流（たかさき ちゃる）
    # 志津利 怜実（しつり れいみ）
    # 加賀 紫翠（かが しすい）
    # 倉重 夢里（くらしげ ゆり）


=head1 DESCRIPTION

Mock::Person::JP generates random sets of Japanese names
by using 123,613 first names and 23,022 last names.

=head1 METHODS

=head2 new()

Creates a new Mock::Person::JP instance.

=head2 create_person(sex => 'male' or 'female')

Creates a new person with a random name. Sex option can take 'male' or 'female',
but 'male' does not work yet because of lack of data.

=head2 name()

See L<Mock::Person::JP::Person>.

=head2 first_name(), last_name(), sei(), mei(), first_name_yomi(), last_name_yomi(), sei_yomi(), mei_yomi()

See L<Mock::Person::JP::Person::Name>.

=head1 LICENSE

=over 2

=item of the Module

Copyright (C) pawa.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=item of 女の子の名前辞書用データ

Copyright (C) ume20＠dd.iij4u.or.jp.

=item of mecab-ipadic

Copyright (C) Nara Institute of Science and Technology (NAIST).

=item of ATOK10/11用人名ﾃｷｽﾄ 35,817語

Copyright (C) 憩舞華.

=item of MS-IME95用人名ﾃｷｽﾄ  23,893語

Copyright (C) 憩舞華.

=back

=head1 SEE ALSO

L<Mock::Person>

=head1 AUTHOR

pawa E<lt>pawa@pawafuru.comE<gt>

=cut
