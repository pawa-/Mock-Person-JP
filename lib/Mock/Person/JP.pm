package Mock::Person::JP;

use 5.008_001;
use strict;
use warnings;
use Carp ();
use File::ShareDir   ();
use File::RandomLine ();
use Mock::Person::JP::Person ();

our $VERSION = "0.06";

sub new
{
    my ($class) = @_;

    my $self = bless {}, $class;

    $self->{sei}         = File::RandomLine->new( File::ShareDir::dist_file('Mock-Person-JP', 'sei.tsv') );
    $self->{mei}{male}   = File::RandomLine->new( File::ShareDir::dist_file('Mock-Person-JP', 'mei_male.tsv') );
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

    # Sample output (UTF-8 flag is on):
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
by using 142,610 first names and 23,021 last names.

=head1 METHODS

=head2 new()

Creates a new Mock::Person::JP instance.

=head2 create_person(sex => 'male' or 'female')

Creates a new person with a random name. Sex option can take 'male' or 'female'.

=head2 name()

See L<Mock::Person::JP::Person>.

=head2 first_name(), last_name(), sei(), mei(), first_name_yomi(), last_name_yomi(), sei_yomi(), mei_yomi()

See L<Mock::Person::JP::Person::Name>.

=head1 LICENSE

=over 2

=item of the Module

Copyright (C) 2014 pawa.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=item of 女の子の名前辞書用データ

Copyright (C) ume20＠dd.iij4u.or.jp.

    あなたは以下の条件に従う場合に限り、自由に
      ・本作品を複製、頒布、展示、実演することができます。
      ・二次的著作物を作成することができます。
      ・本作品を営利目的で利用することができます。

    あなたの従うべき条件は以下の通りです。
      ・帰属. あなたは原著作者のクレジットを表示しなければなりません。
      ・再利用や頒布にあたっては、この作品の使用許諾条件を他の人々に明らかにしなければなりません。
      ・著作[権]者から許可を得ると、これらの条件は適用されません。
      ・上記によってあなたのフェアユースその他の権利が影響を受けることはまったくありません

=item of mecab-ipadic

    Copyright 2000, 2001, 2002, 2003 Nara Institute of Science
    and Technology.  All Rights Reserved.

    Use, reproduction, and distribution of this software is permitted.
    Any copy of this software, whether in its original form or modified,
    must include both the above copyright notice and the following
    paragraphs.

    Nara Institute of Science and Technology (NAIST),
    the copyright holders, disclaims all warranties with regard to this
    software, including all implied warranties of merchantability and
    fitness, in no event shall NAIST be liable for
    any special, indirect or consequential damages or any damages
    whatsoever resulting from loss of use, data or profits, whether in an
    action of contract, negligence or other tortuous action, arising out
    of or in connection with the use or performance of this software.

    A large portion of the dictionary entries
    originate from ICOT Free Software.  The following conditions for ICOT
    Free Software applies to the current dictionary as well.

    Each User may also freely distribute the Program, whether in its
    original form or modified, to any third party or parties, PROVIDED
    that the provisions of Section 3 ("NO WARRANTY") will ALWAYS appear
    on, or be attached to, the Program, which is distributed substantially
    in the same form as set out herein and that such intended
    distribution, if actually made, will neither violate or otherwise
    contravene any of the laws and regulations of the countries having
    jurisdiction over the User or the intended distribution itself.

    NO WARRANTY

    The program was produced on an experimental basis in the course of the
    research and development conducted during the project and is provided
    to users as so produced on an experimental basis.  Accordingly, the
    program is provided without any warranty whatsoever, whether express,
    implied, statutory or otherwise.  The term "warranty" used herein
    includes, but is not limited to, any warranty of the quality,
    performance, merchantability and fitness for a particular purpose of
    the program and the nonexistence of any infringement or violation of
    any right of any third party.

    Each user of the program will agree and understand, and be deemed to
    have agreed and understood, that there is no warranty whatsoever for
    the program and, accordingly, the entire risk arising from or
    otherwise connected with the program is assumed by the user.

    Therefore, neither ICOT, the copyright holder, or any other
    organization that participated in or was otherwise related to the
    development of the program and their respective officials, directors,
    officers and other employees shall be held liable for any and all
    damages, including, without limitation, general, special, incidental
    and consequential damages, arising out of or otherwise in connection
    with the use or inability to use the program or any product, material
    or result produced or otherwise obtained by using the program,
    regardless of whether they have been advised of, or otherwise had
    knowledge of, the possibility of such damages at any time during the
    project or thereafter.  Each user will be deemed to have agreed to the
    foregoing by his or her commencement of use of the program.  The term
    "use" as used herein includes, but is not limited to, the use,
    modification, copying and distribution of the program and the
    production of secondary products from the program.

    In the case where the program, whether in its original form or
    modified, was distributed or delivered to or received by a user from
    any person, organization or entity other than ICOT, unless it makes or
    grants independently of ICOT any specific warranty to the user in
    writing, such person, organization or entity, will also be exempted
    from and not be held liable to the user for any such damages as noted
    above as far as the program is concerned.

=item of ATOK10/11用人名ﾃｷｽﾄ 35,817語

Copyright (C) 憩舞華.

    下記の方をのぞき 金銭を伴わない転載・改編は ご自由にどうぞ
    ﾊﾟｿｺﾝ通信等にてｼｪｱｳｴｱを登録されている方はそのｼｪｱｳｴｱの使用権と引き替えに個人的使用に限り許諾いたします

=item of MS-IME95用人名ﾃｷｽﾄ  23,893語

Copyright (C) 憩舞華.

    下記の方をのぞき 金銭を伴わない転載・改編は ご自由にどうぞ
    ﾊﾟｿｺﾝ通信等にてｼｪｱｳｴｱを登録されている方はそのｼｪｱｳｴｱの使用権と引き替えに個人的使用に限り許諾いたします

=item of Enamdict

Copyright is held by James William BREEN and The Electronic Dictionary Research and Development Group.

The dictionary files are made available under a Creative Commons Attribution-ShareAlike Licence (V3.0).

See L<http://www.edrdg.org/edrdg/licence.html> for the full licence.

=item of share/sei.tsv, share/mei_female.tsv

Copyright (C) pawa.

You can redistribute these files and/or modify these files under the same terms as Perl itself.

=item of share/mei_male.tsv

Copyright (C) pawa.

You can redistribute it and/or modify it under the same licence as Enamdict itself.

This file contains almost all the male given names of Enamdict.

=back

=head1 SEE ALSO

=over 2

=item L<Mock::Person>

=item 戸籍法 第50条

=item 戸籍法施行規則 第60条

=item L<Lingua::JA::KanjiTable>

=back

=head1 CONTRIBUTORS

Ben Bullock (BKB)

=head1 AUTHOR

pawa E<lt>pawa@pawafuru.comE<gt>

=cut
