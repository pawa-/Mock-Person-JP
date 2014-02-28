# NAME

Mock::Person::JP - Generate random sets of Japanese names

# SYNOPSIS

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



# DESCRIPTION

Mock::Person::JP generates random sets of Japanese names
by using 123,613 first names and 23,022 last names.

# METHODS

## new()

Creates a new Mock::Person::JP instance.

## create\_person(sex => 'male' or 'female')

Creates a new person with a random name. Sex option can take 'male' or 'female',
but 'male' does not work yet because of lack of data.

## name()

See [Mock::Person::JP::Person](https://metacpan.org/pod/Mock::Person::JP::Person).

## first\_name(), last\_name(), sei(), mei(), first\_name\_yomi(), last\_name\_yomi(), sei\_yomi(), mei\_yomi()

See [Mock::Person::JP::Person::Name](https://metacpan.org/pod/Mock::Person::JP::Person::Name).

# LICENSE

- of the Module

    Copyright (C) pawa.

    This library is free software; you can redistribute it and/or modify
    it under the same terms as Perl itself.

- of 女の子の名前辞書用データ

    Copyright (C) ume20＠dd.iij4u.or.jp.

- of mecab-ipadic

    Copyright (C) Nara Institute of Science and Technology (NAIST).

- of ATOK10/11用人名ﾃｷｽﾄ 35,817語

    Copyright (C) 憩舞華.

- of MS-IME95用人名ﾃｷｽﾄ  23,893語

    Copyright (C) 憩舞華.

# SEE ALSO

[Mock::Person](https://metacpan.org/pod/Mock::Person)

# AUTHOR

pawa <pawa@pawafuru.com>
