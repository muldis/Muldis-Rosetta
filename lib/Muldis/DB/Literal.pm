use 5.008001;
use utf8;
use strict;
use warnings FATAL => 'all';

###########################################################################
###########################################################################

my $BOOL_FALSE = (1 == 0);
my $BOOL_TRUE  = (1 == 1);

my $ORDER_INCREASE = (1 <=> 2);
my $ORDER_SAME     = (1 <=> 1);
my $ORDER_DECREASE = (2 <=> 1);

my $TYNM_UINT
    = Muldis::DB::Literal::EntityName->new({ 'text' => 'sys.type.UInt' });
my $TYNM_PINT
    = Muldis::DB::Literal::EntityName->new({ 'text' => 'sys.type.PInt' });

my $ATNM_VALUE = Muldis::DB::Literal::EntityName->new({ 'text' => 'value' });
my $ATNM_INDEX = Muldis::DB::Literal::EntityName->new({ 'text' => 'index' });
my $ATNM_COUNT = Muldis::DB::Literal::EntityName->new({ 'text' => 'count' });

my $SCA_TYPE_UINT = Muldis::DB::Literal::TypeInvo->new({
    'kind' => 'Scalar', 'spec' => $TYNM_UINT });
my $SCA_TYPE_PINT = Muldis::DB::Literal::TypeInvo->new({
    'kind' => 'Scalar', 'spec' => $TYNM_PINT });

###########################################################################
###########################################################################

{ package Muldis::DB::Literal; # module
    our $VERSION = 0.003000;
    # Note: This given version applies to all of this file's packages.

    use base 'Exporter';
    our @EXPORT_OK = qw(
        newSet newQuasiSet
        newMaybe newQuasiMaybe
        newSeq newQuasiSeq
        newBag newQuasiBag
    );

    use Carp;

###########################################################################

sub newSet {
    my ($args) = @_;
    my ($heading, $body) = @{$args}{'heading', 'body'};

    confess q{new(): Bad :$body arg; it is not an Array.}
        if ref $body ne 'ARRAY';

    return Muldis::DB::Literal::Relation->new({
        'heading' => Muldis::DB::Literal::TypeDict->new({ 'map' => [
            [$ATNM_VALUE, $heading],
        ] }),
        'body' => [map {
            Muldis::DB::Literal::_ExprDict->new({ 'map' => [
                [$ATNM_VALUE, $_],
            ] }),
        } @{$body}],
    });
}

sub newQuasiSet {
    my ($args) = @_;
    my ($heading, $body) = @{$args}{'heading', 'body'};

    confess q{new(): Bad :$body arg; it is not an Array.}
        if ref $body ne 'ARRAY';

    return Muldis::DB::Literal::QuasiRelation->new({
        'heading' => Muldis::DB::Literal::QuasiTypeDict->new({ 'map' => [
            [$ATNM_VALUE, $heading],
        ] }),
        'body' => [map {
            Muldis::DB::Literal::_ExprDict->new({ 'map' => [
                [$ATNM_VALUE, $_],
            ] }),
        } @{$body}],
    });
}

sub newMaybe {
    my ($args) = @_;
    my ($heading, $body) = @{$args}{'heading', 'body'};

    confess q{new(): Bad :$body arg; it is not a 0..1-element Array.}
        if ref $body ne 'ARRAY' or @{$body} > 1;

    return Muldis::DB::Literal::Relation->new({
        'heading' => Muldis::DB::Literal::TypeDict->new({ 'map' => [
            [$ATNM_VALUE, $heading],
        ] }),
        'body' => [map {
            Muldis::DB::Literal::_ExprDict->new({ 'map' => [
                [$ATNM_VALUE, $_],
            ] }),
        } @{$body}],
    });
}

sub newQuasiMaybe {
    my ($args) = @_;
    my ($heading, $body) = @{$args}{'heading', 'body'};

    confess q{new(): Bad :$body arg; it is not a 0..1-element Array.}
        if ref $body ne 'ARRAY' or @{$body} > 1;

    return Muldis::DB::Literal::QuasiRelation->new({
        'heading' => Muldis::DB::Literal::QuasiTypeDict->new({ 'map' => [
            [$ATNM_VALUE, $heading],
        ] }),
        'body' => [map {
            Muldis::DB::Literal::_ExprDict->new({ 'map' => [
                [$ATNM_VALUE, $_],
            ] }),
        } @{$body}],
    });
}

sub newSeq {
    my ($args) = @_;
    my ($heading, $body) = @{$args}{'heading', 'body'};

    confess q{new(): Bad :$body arg; it is not an Array.}
        if ref $body ne 'ARRAY';
    for my $tbody (@{$body}) {
        confess q{new(): Bad :$body arg elem; it is not a 2-element Array.}
            if ref $tbody ne 'ARRAY' or @{$tbody} != 2;
    }

    return Muldis::DB::Literal::Relation->new({
        'heading' => Muldis::DB::Literal::TypeDict->new({ 'map' => [
            [$ATNM_INDEX, $SCA_TYPE_UINT],
            [$ATNM_VALUE, $heading],
        ] }),
        'body' => [map {
            Muldis::DB::Literal::_ExprDict->new({ 'map' => [
                [$ATNM_INDEX, $_->[0]],
                [$ATNM_VALUE, $_->[1]],
            ] }),
        } @{$body}],
    });
}

sub newQuasiSeq {
    my ($args) = @_;
    my ($heading, $body) = @{$args}{'heading', 'body'};

    confess q{new(): Bad :$body arg; it is not an Array.}
        if ref $body ne 'ARRAY';
    for my $tbody (@{$body}) {
        confess q{new(): Bad :$body arg elem; it is not a 2-element Array.}
            if ref $tbody ne 'ARRAY' or @{$tbody} != 2;
    }

    return Muldis::DB::Literal::QuasiRelation->new({
        'heading' => Muldis::DB::Literal::QuasiTypeDict->new({ 'map' => [
            [$ATNM_INDEX, $SCA_TYPE_UINT],
            [$ATNM_VALUE, $heading],
        ] }),
        'body' => [map {
            Muldis::DB::Literal::_ExprDict->new({ 'map' => [
                [$ATNM_INDEX, $_->[0]],
                [$ATNM_VALUE, $_->[1]],
            ] }),
        } @{$body}],
    });
}

sub newBag {
    my ($args) = @_;
    my ($heading, $body) = @{$args}{'heading', 'body'};

    confess q{new(): Bad :$body arg; it is not an Array.}
        if ref $body ne 'ARRAY';
    for my $tbody (@{$body}) {
        confess q{new(): Bad :$body arg elem; it is not a 2-element Array.}
            if ref $tbody ne 'ARRAY' or @{$tbody} != 2;
    }

    return Muldis::DB::Literal::Relation->new({
        'heading' => Muldis::DB::Literal::TypeDict->new({ 'map' => [
            [$ATNM_VALUE, $heading],
            [$ATNM_COUNT, $SCA_TYPE_PINT],
        ] }),
        'body' => [map {
            Muldis::DB::Literal::_ExprDict->new({ 'map' => [
                [$ATNM_VALUE, $_->[0]],
                [$ATNM_COUNT, $_->[1]],
            ] }),
        } @{$body}],
    });
}

sub newQuasiBag {
    my ($args) = @_;
    my ($heading, $body) = @{$args}{'heading', 'body'};

    confess q{new(): Bad :$body arg; it is not an Array.}
        if ref $body ne 'ARRAY';
    for my $tbody (@{$body}) {
        confess q{new(): Bad :$body arg elem; it is not a 2-element Array.}
            if ref $tbody ne 'ARRAY' or @{$tbody} != 2;
    }

    return Muldis::DB::Literal::QuasiRelation->new({
        'heading' => Muldis::DB::Literal::QuasiTypeDict->new({ 'map' => [
            [$ATNM_VALUE, $heading],
            [$ATNM_COUNT, $SCA_TYPE_PINT],
        ] }),
        'body' => [map {
            Muldis::DB::Literal::_ExprDict->new({ 'map' => [
                [$ATNM_VALUE, $_->[0]],
                [$ATNM_COUNT, $_->[1]],
            ] }),
        } @{$body}],
    });
}

###########################################################################

} # module Muldis::DB::Literal

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::Node;
    use Carp;
    use Scalar::Util qw(blessed);

###########################################################################

sub new {
    my ($class, $args) = @_;
    my $self = bless {}, $class;
    $self->_build( $args );
    return $self;
}

sub _build {
    return; # default for any classes having no attributes
}

###########################################################################

sub as_perl {
    my ($self) = @_;
    confess q{not implemented by subclass } . (blessed $self);
}

###########################################################################

sub equal_repr {
    my ($self, $args) = @_;
    my ($other) = @{$args}{'other'};

    confess q{equal_repr(): Bad :$other arg; it is not a valid object}
            . q{ of a Muldis::DB::Literal::Node-doing class.}
        if !blessed $other or !$other->isa( 'Muldis::DB::Literal::Node' );

    return $BOOL_FALSE
        if blessed $other ne blessed $self;

    return $self->_equal_repr( $other );
}

sub _equal_repr {
    my ($self) = @_;
    confess q{not implemented by subclass } . (blessed $self);
}

###########################################################################

} # role Muldis::DB::Literal::Node

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::Expr; # role
    use base 'Muldis::DB::Literal::Node';
} # role Muldis::DB::Literal::Expr

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::Lit; # role
    use base 'Muldis::DB::Literal::Expr';
} # role Muldis::DB::Literal::Lit

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::Bool; # class
    use base 'Muldis::DB::Literal::Lit';

    use Carp;

    my $FALSE_AS_PERL = qq{'$BOOL_FALSE'};
    my $TRUE_AS_PERL  = qq{'$BOOL_TRUE'};

    my $ATTR_V = 'v';
        # A p5 Scalar that equals $BOOL_FALSE|$BOOL_TRUE.

    my $ATTR_AS_PERL = 'as_perl';

###########################################################################

sub _build {
    my ($self, $args) = @_;
    my ($v) = @{$args}{'v'};

    confess q{new(): Bad :$v arg; Perl 5 does not consider}
            . q{ it to be a canonical boolean value.}
        if !defined $v or ($v ne $BOOL_FALSE and $v ne $BOOL_TRUE);

    $self->{$ATTR_V} = $v;

    return;
}

###########################################################################

sub as_perl {
    my ($self) = @_;
    if (!defined $self->{$ATTR_AS_PERL}) {
        my $s = $self->{$ATTR_V} ? $TRUE_AS_PERL : $FALSE_AS_PERL;
        $self->{$ATTR_AS_PERL}
            = "Muldis::DB::Literal::Bool->new({ 'v' => $s })";
    }
    return $self->{$ATTR_AS_PERL};
}

###########################################################################

sub _equal_repr {
    my ($self, $other) = @_;
    return $other->{$ATTR_V} eq $self->{$ATTR_V};
}

###########################################################################

sub v {
    my ($self) = @_;
    return $self->{$ATTR_V};
}

###########################################################################

} # class Muldis::DB::Literal::Bool

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::Order; # class
    use base 'Muldis::DB::Literal::Lit';

    use Carp;

    my $ATTR_V = 'v';
        # A p5 Scalar that equals $ORDER_(INCREASE|SAME|DECREASE).

    my $ATTR_AS_PERL = 'as_perl';

###########################################################################

sub _build {
    my ($self, $args) = @_;
    my ($v) = @{$args}{'v'};

    confess q{new(): Bad :$v arg; Perl 5 does not consider}
            . q{ it to be a canonical order value.}
        if !defined $v or ($v ne $ORDER_INCREASE
            and $v ne $ORDER_SAME and $v ne $ORDER_DECREASE);

    $self->{$ATTR_V} = $v;

    return;
}

###########################################################################

sub as_perl {
    my ($self) = @_;
    if (!defined $self->{$ATTR_AS_PERL}) {
        my $s = q{'} . $self->{$ATTR_V} . q{'};
        $self->{$ATTR_AS_PERL}
            = "Muldis::DB::Literal::Order->new({ 'v' => $s })";
    }
    return $self->{$ATTR_AS_PERL};
}

###########################################################################

sub _equal_repr {
    my ($self, $other) = @_;
    return $other->{$ATTR_V} eq $self->{$ATTR_V};
}

###########################################################################

sub v {
    my ($self) = @_;
    return $self->{$ATTR_V};
}

###########################################################################

} # class Muldis::DB::Literal::Order

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::Int; # class
    use base 'Muldis::DB::Literal::Lit';

    use Carp;

    my $ATTR_V = 'v';
        # A p5 Scalar that is a Perl integer or BigInt or canonical string.

    my $ATTR_AS_PERL = 'as_perl';

###########################################################################

sub _build {
    my ($self, $args) = @_;
    my ($v) = @{$args}{'v'};

    confess q{new(): Bad :$v arg; Perl 5 does not consider}
            . q{ it to be a canonical integer value.}
        if !defined $v or $v !~ m/\A (0|-?[1-9][0-9]*) \z/xs;

    $self->{$ATTR_V} = $v;

    return;
}

###########################################################################

sub as_perl {
    my ($self) = @_;
    if (!defined $self->{$ATTR_AS_PERL}) {
        my $s = q{'} . $self->{$ATTR_V} . q{'};
        $self->{$ATTR_AS_PERL}
            = "Muldis::DB::Literal::Int->new({ 'v' => $s })";
    }
    return $self->{$ATTR_AS_PERL};
}

###########################################################################

sub _equal_repr {
    my ($self, $other) = @_;
    return $other->{$ATTR_V} eq $self->{$ATTR_V};
}

###########################################################################

sub v {
    my ($self) = @_;
    return $self->{$ATTR_V};
}

###########################################################################

} # class Muldis::DB::Literal::Int

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::Blob; # class
    use base 'Muldis::DB::Literal::Lit';

    use Carp;
    use Encode qw(is_utf8);

    my $ATTR_V = 'v';
        # A p5 Scalar that is a byte-mode string; it has false utf8 flag.

    my $ATTR_AS_PERL = 'as_perl';

###########################################################################

sub _build {
    my ($self, $args) = @_;
    my ($v) = @{$args}{'v'};

    confess q{new(): Bad :$v arg; Perl 5 does not consider}
            . q{ it to be a canonical byte string value.}
        if !defined $v or is_utf8 $v;

    $self->{$ATTR_V} = $v;

    return;
}

###########################################################################

sub as_perl {
    my ($self) = @_;
    if (!defined $self->{$ATTR_AS_PERL}) {
        # TODO: A proper job of encoding/decoding the bit string payload.
        # What you see below is more symbolic of what to do than correct.
        my $hex_digit_text = join q{}, map { unpack 'H2', $_ }
            split q{}, $self->{$ATTR_V};
        my $s = q[(join q{}, map { pack 'H2', $_ }
            split q{}, ] . $hex_digit_text . q[)];
        $self->{$ATTR_AS_PERL}
            = "Muldis::DB::Literal::Blob->new({ 'v' => $s })";
    }
    return $self->{$ATTR_AS_PERL};
}

###########################################################################

sub _equal_repr {
    my ($self, $other) = @_;
    return $other->{$ATTR_V} eq $self->{$ATTR_V};
}

###########################################################################

sub v {
    my ($self) = @_;
    return $self->{$ATTR_V};
}

###########################################################################

} # class Muldis::DB::Literal::Blob

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::Text; # class
    use base 'Muldis::DB::Literal::Lit';

    use Carp;
    use Encode qw(is_utf8);

    my $ATTR_V = 'v';
        # A p5 Scalar that is a text-mode string;
        # it either has true utf8 flag or is only 7-bit bytes.

    my $ATTR_AS_PERL = 'as_perl';

###########################################################################

sub _build {
    my ($self, $args) = @_;
    my ($v) = @{$args}{'v'};

    confess q{new(): Bad :$v arg; Perl 5 does not consider}
            . q{ it to be a canonical character string value.}
        if !defined $v or (!is_utf8 $v and $v =~ m/[^\x00-\x7F]/xs);

    $self->{$ATTR_V} = $v;

    return;
}

###########################################################################

sub as_perl {
    my ($self) = @_;
    if (!defined $self->{$ATTR_AS_PERL}) {
        my $s = $self->{$ATTR_V};
        $s =~ s/\\/\\\\/xsg;
        $s =~ s/'/\\'/xsg;
        $s = q{'} . $s . q{'};
        $self->{$ATTR_AS_PERL}
            = "Muldis::DB::Literal::Text->new({ 'v' => $s })";
    }
    return $self->{$ATTR_AS_PERL};
}

###########################################################################

sub _equal_repr {
    my ($self, $other) = @_;
    return $other->{$ATTR_V} eq $self->{$ATTR_V};
}

###########################################################################

sub v {
    my ($self) = @_;
    return $self->{$ATTR_V};
}

###########################################################################

} # class Muldis::DB::Literal::Text

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::_Tuple; # role
    use base 'Muldis::DB::Literal::Expr';

    use Carp;
    use Scalar::Util qw(blessed);

    my $ATTR_HEADING = 'heading';
    my $ATTR_BODY    = 'body';

    my $ATTR_AS_PERL = 'as_perl';

    my $TYPEDICT_ATTR_MAP_HOA  = 'map_hoa';
    my $EXPRDICT_ATTR_MAP_HOA  = 'map_hoa';

###########################################################################

sub _build {
    my ($self, $args) = @_;
    my ($heading, $body) = @{$args}{'heading', 'body'};

    if ($self->_allows_quasi()) {
        confess q{new(): Bad :$heading arg; it is not a valid object}
                . q{ of a Muldis::DB::Literal::QuasiTypeDict-doing class.}
            if !blessed $heading
                or !$heading->isa( 'Muldis::DB::Literal::QuasiTypeDict' );
    }
    else {
        confess q{new(): Bad :$heading arg; it is not a valid object}
                . q{ of a Muldis::DB::Literal::TypeDict-doing class.}
            if !blessed $heading
                or !$heading->isa( 'Muldis::DB::Literal::TypeDict' );
    }
    my $heading_attrs_count = $heading->elem_count();
    my $heading_attrs_map_hoa = $heading->{$TYPEDICT_ATTR_MAP_HOA};

    confess q{new(): Bad :$body arg; it is not a valid object}
            . q{ of a Muldis::DB::Literal::_ExprDict-doing class.}
        if !blessed $body or !$body->isa( 'Muldis::DB::Literal::_ExprDict' );
    confess q{new(): Bad :$body arg; it does not have the}
            . q{ same attr count as :$heading.}
        if $body->elem_count() != $heading_attrs_count;
    for my $attr_name_text (keys %{$body->{$EXPRDICT_ATTR_MAP_HOA}}) {
        confess q{new(): Bad :$body arg; at least one its attrs}
                . q{ does not have a corresponding attr in :$heading.}
            if !exists $heading_attrs_map_hoa->{$attr_name_text};
    }

    $self->{$ATTR_HEADING} = $heading;
    $self->{$ATTR_BODY}    = $body;

    return;
}

###########################################################################

sub as_perl {
    my ($self) = @_;
    if (!defined $self->{$ATTR_AS_PERL}) {
        my $self_class = blessed $self;
        my $sh = $self->{$ATTR_HEADING}->as_perl();
        my $sb = $self->{$ATTR_BODY}->as_perl();
        $self->{$ATTR_AS_PERL}
            = "$self_class->new({ 'heading' => $sh, 'body' => $sb })";
    }
    return $self->{$ATTR_AS_PERL};
}

###########################################################################

sub _equal_repr {
    my ($self, $other) = @_;
    return ($self->{$ATTR_HEADING}->equal_repr({
            'other' => $other->{$ATTR_HEADING} })
        and $self->{$ATTR_BODY}->equal_repr({
            'other' => $other->{$ATTR_BODY} }));
}

###########################################################################

sub heading {
    my ($self) = @_;
    return $self->{$ATTR_HEADING};
}

sub body {
    my ($self) = @_;
    return $self->{$ATTR_BODY};
}

###########################################################################

sub attr_count {
    my ($self) = @_;
    return $self->{$ATTR_HEADING}->elem_count();
}

sub attr_exists {
    my ($self, $args) = @_;
    my ($attr_name) = @{$args}{'attr_name'};
    return $self->{$ATTR_HEADING}->elem_exists({
        'elem_name' => $attr_name });
}

sub attr_type {
    my ($self, $args) = @_;
    my ($attr_name) = @{$args}{'attr_name'};
    return $self->{$ATTR_HEADING}->elem_value({
        'elem_name' => $attr_name });
}

sub attr_value {
    my ($self, $args) = @_;
    my ($attr_name) = @{$args}{'attr_name'};
    return $self->{$ATTR_BODY}->elem_value({ 'elem_name' => $attr_name });
}

###########################################################################

} # role Muldis::DB::Literal::_Tuple

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::Tuple; # class
    use base 'Muldis::DB::Literal::_Tuple';
    sub _allows_quasi { return $BOOL_FALSE; }
} # class Muldis::DB::Literal::Tuple

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::QuasiTuple; # class
    use base 'Muldis::DB::Literal::_Tuple';
    sub _allows_quasi { return $BOOL_TRUE; }
} # class Muldis::DB::Literal::QuasiTuple

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::_Relation; # role
    use base 'Muldis::DB::Literal::Expr';

    use Carp;
    use Scalar::Util qw(blessed);

    my $ATTR_HEADING = 'heading';
    my $ATTR_BODY    = 'body';

    my $ATTR_AS_PERL = 'as_perl';

    my $TYPEDICT_ATTR_MAP_HOA  = 'map_hoa';
    my $EXPRDICT_ATTR_MAP_HOA  = 'map_hoa';

###########################################################################

sub _build {
    my ($self, $args) = @_;
    my ($heading, $body) = @{$args}{'heading', 'body'};

    if ($self->_allows_quasi()) {
        confess q{new(): Bad :$heading arg; it is not a valid object}
                . q{ of a Muldis::DB::Literal::QuasiTypeDict-doing class.}
            if !blessed $heading
                or !$heading->isa( 'Muldis::DB::Literal::QuasiTypeDict' );
    }
    else {
        confess q{new(): Bad :$heading arg; it is not a valid object}
                . q{ of a Muldis::DB::Literal::TypeDict-doing class.}
            if !blessed $heading
                or !$heading->isa( 'Muldis::DB::Literal::TypeDict' );
    }
    my $heading_attrs_count = $heading->elem_count();
    my $heading_attrs_map_hoa = $heading->{$TYPEDICT_ATTR_MAP_HOA};

    confess q{new(): Bad :$body arg; it is not an Array.}
        if ref $body ne 'ARRAY';
    for my $tupb (@{$body}) {
        confess q{new(): Bad :$body arg elem; it is not a valid object}
                . q{ of a Muldis::DB::Literal::_ExprDict-doing class.}
            if !blessed $tupb
                or !$tupb->isa( 'Muldis::DB::Literal::_ExprDict' );
        confess q{new(): Bad :$body arg elem; it does not have the}
                . q{ same attr count as :$heading.}
            if $tupb->elem_count() != $heading_attrs_count;
        for my $attr_name_text (keys %{$tupb->{$EXPRDICT_ATTR_MAP_HOA}}) {
            confess q{new(): Bad :$body arg elem; at least one its attrs}
                    . q{ does not have a corresponding attr in :$heading.}
                if !exists $heading_attrs_map_hoa->{$attr_name_text};
        }
    }

    $self->{$ATTR_HEADING} = $heading;
    $self->{$ATTR_BODY}    = [@{$body}];

    return;
}

###########################################################################

sub as_perl {
    my ($self) = @_;
    if (!defined $self->{$ATTR_AS_PERL}) {
        my $self_class = blessed $self;
        my $sh = $self->{$ATTR_HEADING}->as_perl();
        my $sb = q{[} . (join q{, }, map {
                $_->as_perl()
            } @{$self->{$ATTR_BODY}}) . q{]};
        $self->{$ATTR_AS_PERL}
            = "$self_class->new({ 'heading' => $sh, 'body' => $sb })";
    }
    return $self->{$ATTR_AS_PERL};
}

###########################################################################

sub _equal_repr {
    my ($self, $other) = @_;
    return $BOOL_FALSE
        if !$self->{$ATTR_HEADING}->equal_repr({
            'other' => $other->{$ATTR_HEADING} });
    my $v1 = $self->{$ATTR_BODY};
    my $v2 = $other->{$ATTR_BODY};
    return $BOOL_FALSE
        if @{$v2} != @{$v1};
    for my $i (0..$#{$v1}) {
        return $BOOL_FALSE
            if !$v1->[$i]->equal_repr({ 'other' => $v2->[$i] });
    }
    return $BOOL_TRUE;
}

###########################################################################

sub heading {
    my ($self) = @_;
    return $self->{$ATTR_HEADING};
}

sub body {
    my ($self) = @_;
    return [@{$self->{$ATTR_BODY}}];
}

###########################################################################

sub body_repr_elem_count {
    my ($self) = @_;
    return 0 + @{$self->{$ATTR_BODY}};
}

###########################################################################

sub attr_count {
    my ($self) = @_;
    return $self->{$ATTR_HEADING}->elem_count();
}

sub attr_exists {
    my ($self, $args) = @_;
    my ($attr_name) = @{$args}{'attr_name'};
    return $self->{$ATTR_HEADING}->elem_exists({
        'elem_name' => $attr_name });
}

sub attr_type {
    my ($self, $args) = @_;
    my ($attr_name) = @{$args}{'attr_name'};
    return $self->{$ATTR_HEADING}->elem_value({
        'elem_name' => $attr_name });
}

sub attr_values {
    my ($self, $args) = @_;
    my ($attr_name) = @{$args}{'attr_name'};
    return [map {
            $_->elem_value({ 'elem_name' => $attr_name })
        } @{$self->{$ATTR_BODY}}];
}

###########################################################################

sub heading_of_SSBM {
    my ($self) = @_;
    return $self->{$ATTR_HEADING}->elem_value({
        'elem_name' => $ATNM_VALUE });
}

sub body_of_Set {
    my ($self) = @_;
    return [map {
            $_->elem_value({ 'elem_name' => $ATNM_VALUE })
        } @{$self->{$ATTR_BODY}}];
}

sub body_of_Seq {
    my ($self) = @_;
    return [map { [
            $_->elem_value({ 'elem_name' => $ATNM_INDEX }),
            $_->elem_value({ 'elem_name' => $ATNM_VALUE }),
        ] } @{$self->{$ATTR_BODY}}];
}

sub body_of_Bag {
    my ($self) = @_;
    return [map { [
            $_->elem_value({ 'elem_name' => $ATNM_VALUE }),
            $_->elem_value({ 'elem_name' => $ATNM_COUNT }),
        ] } @{$self->{$ATTR_BODY}}];
}

sub body_of_Maybe {
    my ($self) = @_;
    return [map {
            $_->elem_value({ 'elem_name' => $ATNM_VALUE })
        } @{$self->{$ATTR_BODY}}];
}

###########################################################################

} # role Muldis::DB::Literal::_Relation

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::Relation; # class
    use base 'Muldis::DB::Literal::_Relation';
    sub _allows_quasi { return $BOOL_FALSE; }
} # class Muldis::DB::Literal::Relation

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::QuasiRelation; # class
    use base 'Muldis::DB::Literal::_Relation';
    sub _allows_quasi { return $BOOL_TRUE; }
} # class Muldis::DB::Literal::QuasiRelation

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::Default; # class
    use base 'Muldis::DB::Literal::Expr';

    use Carp;
    use Scalar::Util qw(blessed);

    my $ATTR_OF = 'of';

    my $ATTR_AS_PERL = 'as_perl';

###########################################################################

sub _build {
    my ($self, $args) = @_;
    my ($of) = @{$args}{'of'};

    confess q{new(): Bad :$of arg; it is not a valid object}
            . q{ of a Muldis::DB::Literal::_TypeInvo-doing class.}
        if !blessed $of or !$of->isa( 'Muldis::DB::Literal::_TypeInvo' );

    $self->{$ATTR_OF} = $of;

    return;
}

###########################################################################

sub as_perl {
    my ($self) = @_;
    if (!defined $self->{$ATTR_AS_PERL}) {
        my $so = $self->{$ATTR_OF}->as_perl();
        $self->{$ATTR_AS_PERL}
            = "Muldis::DB::Literal::Default->new({ 'of' => $so })";
    }
    return $self->{$ATTR_AS_PERL};
}

###########################################################################

sub _equal_repr {
    my ($self, $other) = @_;
    return $self->{$ATTR_OF}->equal_repr({
        'other' => $other->{$ATTR_OF} });
}

###########################################################################

sub of {
    my ($self) = @_;
    return $self->{$ATTR_OF};
}

###########################################################################

} # class Muldis::DB::Literal::Default

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::Treat; # class
    use base 'Muldis::DB::Literal::Expr';

    use Carp;
    use Scalar::Util qw(blessed);

    my $ATTR_AS = 'as';
    my $ATTR_V  = 'v';

    my $ATTR_AS_PERL = 'as_perl';

###########################################################################

sub _build {
    my ($self, $args) = @_;
    my ($as, $v) = @{$args}{'as', 'v'};

    confess q{new(): Bad :$as arg; it is not a valid object}
            . q{ of a Muldis::DB::Literal::_TypeInvo-doing class.}
        if !blessed $as or !$as->isa( 'Muldis::DB::Literal::_TypeInvo' );

    confess q{new(): Bad :$v arg; it is not a valid object}
            . q{ of a Muldis::DB::Literal::Expr-doing class.}
        if !blessed $v or !$v->isa( 'Muldis::DB::Literal::Expr' );

    $self->{$ATTR_AS} = $as;
    $self->{$ATTR_V}  = $v;

    return;
}

###########################################################################

sub as_perl {
    my ($self) = @_;
    if (!defined $self->{$ATTR_AS_PERL}) {
        my $sa = $self->{$ATTR_AS}->as_perl();
        my $sv = $self->{$ATTR_V}->as_perl();
        $self->{$ATTR_AS_PERL}
            = "Muldis::DB::Literal::Treat->new({ 'as' => $sa, 'v' => $sv })";
    }
    return $self->{$ATTR_AS_PERL};
}

###########################################################################

sub _equal_repr {
    my ($self, $other) = @_;
    return ($self->{$ATTR_AS}->equal_repr({
            'other' => $other->{$ATTR_AS} })
        and $self->{$ATTR_V}->equal_repr({
            'other' => $other->{$ATTR_V} }));
}

###########################################################################

sub as {
    my ($self) = @_;
    return $self->{$ATTR_AS};
}

sub v {
    my ($self) = @_;
    return $self->{$ATTR_V};
}

###########################################################################

} # class Muldis::DB::Literal::Treat

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::VarInvo; # class
    use base 'Muldis::DB::Literal::Expr';

    use Carp;
    use Scalar::Util qw(blessed);

    my $ATTR_V = 'v';

    my $ATTR_AS_PERL = 'as_perl';

###########################################################################

sub _build {
    my ($self, $args) = @_;
    my ($v) = @{$args}{'v'};

    confess q{new(): Bad :$v arg; it is not a valid object}
            . q{ of a Muldis::DB::Literal::EntityName-doing class.}
        if !blessed $v or !$v->isa( 'Muldis::DB::Literal::EntityName' );

    $self->{$ATTR_V} = $v;

    return;
}

###########################################################################

sub as_perl {
    my ($self) = @_;
    if (!defined $self->{$ATTR_AS_PERL}) {
        my $s = $self->{$ATTR_V}->as_perl();
        $self->{$ATTR_AS_PERL}
            = "Muldis::DB::Literal::VarInvo->new({ 'v' => $s })";
    }
    return $self->{$ATTR_AS_PERL};
}

###########################################################################

sub _equal_repr {
    my ($self, $other) = @_;
    return $self->{$ATTR_V}->equal_repr({ 'other' => $other->{$ATTR_V} });
}

###########################################################################

sub v {
    my ($self) = @_;
    return $self->{$ATTR_V};
}

###########################################################################

} # class Muldis::DB::Literal::VarInvo

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::FuncInvo; # class
    use base 'Muldis::DB::Literal::Expr';

    use Carp;
    use Scalar::Util qw(blessed);

    my $ATTR_FUNC    = 'func';
    my $ATTR_RO_ARGS = 'ro_args';

    my $ATTR_AS_PERL = 'as_perl';

###########################################################################

sub _build {
    my ($self, $args) = @_;
    my ($func, $ro_args) = @{$args}{'func', 'ro_args'};

    confess q{new(): Bad :$func arg; it is not a valid object}
            . q{ of a Muldis::DB::Literal::EntityName-doing class.}
        if !blessed $func or !$func->isa( 'Muldis::DB::Literal::EntityName' );

    confess q{new(): Bad :$ro_args arg; it is not a valid object}
            . q{ of a Muldis::DB::Literal::_ExprDict-doing class.}
        if !blessed $ro_args
            or !$ro_args->isa( 'Muldis::DB::Literal::_ExprDict' );

    $self->{$ATTR_FUNC}    = $func;
    $self->{$ATTR_RO_ARGS} = $ro_args;

    return;
}

###########################################################################

sub as_perl {
    my ($self) = @_;
    if (!defined $self->{$ATTR_AS_PERL}) {
        my $sf = $self->{$ATTR_FUNC}->as_perl();
        my $sra = $self->{$ATTR_RO_ARGS}->as_perl();
        $self->{$ATTR_AS_PERL}
            = "Muldis::DB::Literal::FuncInvo->new({"
                . " 'func' => $sf, 'ro_args' => $sra })";
    }
    return $self->{$ATTR_AS_PERL};
}

###########################################################################

sub _equal_repr {
    my ($self, $other) = @_;
    return $self->{$ATTR_FUNC}->equal_repr({
            'other' => $other->{$ATTR_FUNC} })
        and $self->{$ATTR_RO_ARGS}->equal_repr({
            'other' => $other->{$ATTR_RO_ARGS} });
}

###########################################################################

sub func {
    my ($self) = @_;
    return $self->{$ATTR_FUNC};
}

sub ro_args {
    my ($self) = @_;
    return $self->{$ATTR_RO_ARGS};
}

###########################################################################

} # class Muldis::DB::Literal::FuncInvo

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::Stmt; # role
    use base 'Muldis::DB::Literal::Node';
} # role Muldis::DB::Literal::Stmt

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::ProcInvo; # class
    use base 'Muldis::DB::Literal::Stmt';

    use Carp;
    use Scalar::Util qw(blessed);

    my $ATTR_PROC     = 'proc';
    my $ATTR_UPD_ARGS = 'upd_args';
    my $ATTR_RO_ARGS  = 'ro_args';

    my $ATTR_AS_PERL = 'as_perl';

    my $EXPRDICT_ATTR_MAP_HOA = 'map_hoa';

###########################################################################

sub _build {
    my ($self, $args) = @_;
    my ($proc, $upd_args, $ro_args)
        = @{$args}{'proc', 'upd_args', 'ro_args'};

    confess q{new(): Bad :$proc arg; it is not a valid object}
            . q{ of a Muldis::DB::Literal::EntityName-doing class.}
        if !blessed $proc or !$proc->isa( 'Muldis::DB::Literal::EntityName' );

    confess q{new(): Bad :$upd_args arg; it is not a valid object}
            . q{ of a Muldis::DB::Literal::_ExprDict-doing class.}
        if !blessed $upd_args
            or !$upd_args->isa( 'Muldis::DB::Literal::_ExprDict' );
    confess q{new(): Bad :$ro_args arg; it is not a valid object}
            . q{ of a Muldis::DB::Literal::_ExprDict-doing class.}
        if !blessed $ro_args
            or !$ro_args->isa( 'Muldis::DB::Literal::_ExprDict' );
    my $upd_args_map_hoa = $upd_args->{$EXPRDICT_ATTR_MAP_HOA};
    for my $an_and_vn (values %{$upd_args_map_hoa}) {
        confess q{new(): Bad :$upd_args arg elem expr; it is not}
                . q{ an object of a Muldis::DB::Literal::VarInvo-doing class.}
            if !$an_and_vn->[1]->isa( 'Muldis::DB::Literal::VarInvo' );
    }
    confess q{new(): Bad :$upd_args or :$ro_args arg;}
            . q{ they both reference at least 1 same procedure param.}
        if grep {
                exists $upd_args_map_hoa->{$_}
            } keys %{$ro_args->{$EXPRDICT_ATTR_MAP_HOA}};

    $self->{$ATTR_PROC}     = $proc;
    $self->{$ATTR_UPD_ARGS} = $upd_args;
    $self->{$ATTR_RO_ARGS}  = $ro_args;

    return;
}

###########################################################################

sub as_perl {
    my ($self) = @_;
    if (!defined $self->{$ATTR_AS_PERL}) {
        my $sp = $self->{$ATTR_PROC}->as_perl();
        my $sua = $self->{$ATTR_UPD_ARGS}->as_perl();
        my $sra = $self->{$ATTR_RO_ARGS}->as_perl();
        $self->{$ATTR_AS_PERL}
            = "Muldis::DB::Literal::ProcInvo->new({ 'proc' => $sp"
                . ", 'upd_args' => $sua, 'ro_args' => $sra })";
    }
    return $self->{$ATTR_AS_PERL};
}

###########################################################################

sub _equal_repr {
    my ($self, $other) = @_;
    return $self->{$ATTR_PROC}->equal_repr({
            'other' => $other->{$ATTR_PROC} })
        and $self->{$ATTR_UPD_ARGS}->equal_repr({
            'other' => $other->{$ATTR_UPD_ARGS} })
        and $self->{$ATTR_RO_ARGS}->equal_repr({
            'other' => $other->{$ATTR_RO_ARGS} });
}

###########################################################################

sub proc {
    my ($self) = @_;
    return $self->{$ATTR_PROC};
}

sub upd_args {
    my ($self) = @_;
    return $self->{$ATTR_UPD_ARGS};
}

sub ro_args {
    my ($self) = @_;
    return $self->{$ATTR_RO_ARGS};
}

###########################################################################

} # class Muldis::DB::Literal::ProcInvo

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::FuncReturn; # class
    use base 'Muldis::DB::Literal::Stmt';

    use Carp;
    use Scalar::Util qw(blessed);

    my $ATTR_V = 'v';

    my $ATTR_AS_PERL = 'as_perl';

###########################################################################

sub _build {
    my ($self, $args) = @_;
    my ($v) = @{$args}{'v'};

    confess q{new(): Bad :$v arg; it is not a valid object}
            . q{ of a Muldis::DB::Literal::Expr-doing class.}
        if !blessed $v or !$v->isa( 'Muldis::DB::Literal::Expr' );

    $self->{$ATTR_V} = $v;

    return;
}

###########################################################################

sub as_perl {
    my ($self) = @_;
    if (!defined $self->{$ATTR_AS_PERL}) {
        my $s = $self->{$ATTR_V}->as_perl();
        $self->{$ATTR_AS_PERL}
            = "Muldis::DB::Literal::FuncReturn->new({ 'v' => $s })";
    }
    return $self->{$ATTR_AS_PERL};
}

###########################################################################

sub _equal_repr {
    my ($self, $other) = @_;
    return $self->{$ATTR_V}->equal_repr({ 'other' => $other->{$ATTR_V} });
}

###########################################################################

sub v {
    my ($self) = @_;
    return $self->{$ATTR_V};
}

###########################################################################

} # class Muldis::DB::Literal::FuncReturn

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::ProcReturn; # class
    use base 'Muldis::DB::Literal::Stmt';

###########################################################################

sub as_perl {
    return 'Muldis::DB::Literal::ProcReturn->new()';
}

###########################################################################

sub _equal_repr {
    return $BOOL_TRUE;
}

###########################################################################

} # class Muldis::DB::Literal::ProcReturn

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::EntityName; # class
    use base 'Muldis::DB::Literal::Node';

    use Carp;
    use Encode qw(is_utf8);

    my $ATTR_TEXT_POSSREP;
    BEGIN { $ATTR_TEXT_POSSREP = 'text_possrep'; }
        # A p5 Scalar that is a text-mode string;
        # it either has true utf8 flag or is only 7-bit bytes.
    my $ATTR_SEQ_POSSREP;
    BEGIN { $ATTR_SEQ_POSSREP = 'seq_possrep'; }
        # A p5 Array whose elements are p5 Scalar as per the text possrep.

    my $ATTR_AS_PERL = 'as_perl';

###########################################################################

sub _build {
    my ($self, $args) = @_;
    my ($text, $seq) = @{$args}{'text', 'seq'};

    confess q{new(): Exactly 1 of the args (:$text|:$seq) must be defined.}
        if !(defined $text xor defined $seq);

    if (defined $text) {
        confess q{new(): Bad :$text arg; Perl 5 does not consider}
                . q{ it to be a canonical character string value.}
            if !is_utf8 $text and $text =~ m/[^\x00-\x7F]/xs;
        confess q{new(): Bad :$text arg; it contains charac sequences that}
                . q{ are invalid within the Text possrep of an EntityName.}
            if $text =~ m/ \\ \z/xs or $text =~ m/ \\ [^bp] /xs;

        $self->{$ATTR_TEXT_POSSREP} = $text;
        $self->{$ATTR_SEQ_POSSREP} = [map {
                my $s = $_;
                $s =~ s/ \\ p /./xsg;
                $s =~ s/ \\ b /\\/xsg;
                $s;
            } split /\./, $text];
    }

    else { # defined $seq
        confess q{new(): Bad :$seq arg; it is not an Array}
                . q{, or it has < 1 elem.}
            if ref $seq ne 'ARRAY' or @{$seq} == 0;
        for my $seq_e (@{$seq}) {
            confess q{new(): Bad :$seq arg elem; Perl 5 does not consider}
                    . q{ it to be a canonical character string value.}
                if !defined $seq_e
                    or (!is_utf8 $seq_e and $seq_e =~ m/[^\x00-\x7F]/xs);
        }

        $self->{$ATTR_TEXT_POSSREP} = join q{.}, map {
                my $s = $_;
                $s =~ s/ \\ /\\b/xsg;
                $s =~ s/ \. /\\p/xsg;
                $s;
            } @{$seq};
        $self->{$ATTR_SEQ_POSSREP} = [@{$seq}];
    }

    return;
}

###########################################################################

sub as_perl {
    my ($self) = @_;
    if (!defined $self->{$ATTR_AS_PERL}) {
        my $s = $self->{$ATTR_TEXT_POSSREP};
        $s =~ s/\\/\\\\/xsg;
        $s =~ s/'/\\'/xsg;
        $s = q{'} . $s . q{'};
        $self->{$ATTR_AS_PERL}
            = "Muldis::DB::Literal::EntityName->new({ 'text' => $s })";
    }
    return $self->{$ATTR_AS_PERL};
}

###########################################################################

sub _equal_repr {
    my ($self, $other) = @_;
    return $other->{$ATTR_TEXT_POSSREP} eq $self->{$ATTR_TEXT_POSSREP};
}

###########################################################################

sub text {
    my ($self) = @_;
    return $self->{$ATTR_TEXT_POSSREP};
}

sub seq {
    my ($self) = @_;
    return [@{$self->{$ATTR_SEQ_POSSREP}}];
}

###########################################################################

} # class Muldis::DB::Literal::EntityName

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::_TypeInvo; # role
    use base 'Muldis::DB::Literal::Node';

    use Carp;
    use Scalar::Util qw(blessed);

    my $ATTR_KIND;
    BEGIN { $ATTR_KIND = 'kind'; }
    my $ATTR_SPEC;
    BEGIN { $ATTR_SPEC = 'spec'; }

    my $ATTR_AS_PERL = 'as_perl';

###########################################################################

sub _build {
    my ($self, $args) = @_;
    my ($kind, $spec) = @{$args}{'kind', 'spec'};

    confess q{new(): Bad :$kind arg; it is undefined.}
        if !defined $kind;

    if ($kind eq 'Scalar') {
        confess q{new(): Bad :$spec arg; it needs to be a valid object}
                . q{ of a Muldis::DB::Literal::EntityName-doing class}
                . q{ when the :$kind arg is 'Scalar'.}
            if !blessed $spec
                or !$spec->isa( 'Muldis::DB::Literal::EntityName' );
    }

    elsif ($kind eq 'Tuple' or $kind eq 'Relation') {
        confess q{new(): Bad :$spec arg; it needs to be a valid object}
                . q{ of a Muldis::DB::Literal::TypeDict-doing class}
                . q{ when the :$kind arg is 'Tuple'|'Relation'.}
            if !blessed $spec
                or !$spec->isa( 'Muldis::DB::Literal::TypeDict' );
    }

    elsif (!$self->_allows_quasi()) {
        confess q{new(): Bad :$kind arg; it needs to be one of}
            . q{ 'Scalar'|'Tuple'|'Relation'.};
    }

    elsif ($kind eq 'QTuple' or $kind eq 'QRelation') {
        confess q{new(): Bad :$spec arg; it needs to be a valid object}
                . q{ of a Muldis::DB::Literal::QuasiTypeDict-doing class}
                . q{ when the :$kind arg is 'QTuple'|'QRelation'.}
            if !blessed $spec
                or !$spec->isa( 'Muldis::DB::Literal::QuasiTypeDict' );
    }

    elsif ($kind eq 'Any') {
        confess q{new(): Bad :$spec arg; it needs to be one of}
                . q{ 'Tuple'|'Relation'|'QTuple'|'QRelation'|'Universal'}
                . q{ when the :$kind arg is 'Any'.}
            if !defined $spec
                or $spec !~ m/\A (Tuple|Relation
                    |QTuple|QRelation|Universal) \z/xs;
    }

    else {
        confess q{new(): Bad :$kind arg; it needs to be}
            . q{ 'Scalar'|'Tuple'|'Relation'|'QTuple'|'QRelation'|'Any'.};
    }

    $self->{$ATTR_KIND} = $kind;
    $self->{$ATTR_SPEC} = $spec;

    return;
}

###########################################################################

sub as_perl {
    my ($self) = @_;
    if (!defined $self->{$ATTR_AS_PERL}) {
        my $self_class = blessed $self;
        my $kind = $self->{$ATTR_KIND};
        my $spec = $self->{$ATTR_SPEC};
        my $sk = q{'} . $kind . q{'};
        my $ss = $kind eq 'Any' ? q{'} . $spec . q{'} : $spec->as_perl();
        $self->{$ATTR_AS_PERL}
            = "$self_class->new({ 'kind' => $sk, 'spec' => $ss })";
    }
    return $self->{$ATTR_AS_PERL};
}

###########################################################################

sub _equal_repr {
    my ($self, $other) = @_;
    my $kind = $self->{$ATTR_KIND};
    my $spec = $self->{$ATTR_SPEC};
    return $BOOL_FALSE
        if $other->{$ATTR_KIND} ne $kind;
    return $kind eq 'Any' ? $other->{$ATTR_SPEC} eq $spec
        : $spec->equal_repr({ 'other' => $other->{$ATTR_SPEC} });
}

###########################################################################

sub kind {
    my ($self) = @_;
    return $self->{$ATTR_KIND};
}

sub spec {
    my ($self) = @_;
    return $self->{$ATTR_SPEC};
}

###########################################################################

} # role Muldis::DB::Literal::_TypeInvo

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::TypeInvo; # class
    use base 'Muldis::DB::Literal::_TypeInvo';
    sub _allows_quasi { return $BOOL_FALSE; }
} # class Muldis::DB::Literal::TypeInvo

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::QuasiTypeInvo; # class
    use base 'Muldis::DB::Literal::_TypeInvo';
    sub _allows_quasi { return $BOOL_TRUE; }
} # class Muldis::DB::Literal::QuasiTypeInvo

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::_TypeDict; # role
    use base 'Muldis::DB::Literal::Node';

    use Carp;
    use Scalar::Util qw(blessed);

    my $ATTR_MAP_AOA = 'map_aoa';
    my $ATTR_MAP_HOA = 'map_hoa';

    my $ATTR_AS_PERL = 'as_perl';

###########################################################################

sub _build {
    my ($self, $args) = @_;
    my ($map) = @{$args}{'map'};

    my $allows_quasi = $self->_allows_quasi();

    confess q{new(): Bad :$map arg; it is not an Array.}
        if ref $map ne 'ARRAY';
    my $map_aoa = [];
    my $map_hoa = {};
    for my $elem (@{$map}) {
        confess q{new(): Bad :$map arg elem; it is not a 2-element Array.}
            if ref $elem ne 'ARRAY' or @{$elem} != 2;
        my ($entity_name, $type_invo) = @{$elem};
        confess q{new(): Bad :$map arg elem; its first elem is not an}
                . q{ object of a Muldis::DB::Literal::EntityName-doing class.}
            if !blessed $entity_name
                or !$entity_name->isa( 'Muldis::DB::Literal::EntityName' );
        my $entity_name_text = $entity_name->text();
        confess q{new(): Bad :$map arg elem; its first elem is not}
                . q{ distinct between the arg elems.}
            if exists $map_hoa->{$entity_name_text};
        if ($allows_quasi) {
            confess q{new(): Bad :$map arg elem; its second elem is not an}
                    . q{ object of a Muldis::DB::Literal::QuasiTypeInvo-doing}
                    . q{ class.}
                if !blessed $type_invo
                    or !$type_invo->isa( 'Muldis::DB::Literal::QuasiTypeInvo' );
        }
        else {
            confess q{new(): Bad :$map arg elem; its second elem is not an}
                    . q{ object of a Muldis::DB::Literal::TypeInvo-doing}
                    . q{ class.}
                if !blessed $type_invo
                    or !$type_invo->isa( 'Muldis::DB::Literal::TypeInvo' );
        }
        my $elem_cpy = [$entity_name, $type_invo];
        push @{$map_aoa}, $elem_cpy;
        $map_hoa->{$entity_name_text} = $elem_cpy;
    }

    $self->{$ATTR_MAP_AOA} = $map_aoa;
    $self->{$ATTR_MAP_HOA} = $map_hoa;

    return;
}

###########################################################################

sub as_perl {
    my ($self) = @_;
    if (!defined $self->{$ATTR_AS_PERL}) {
        my $s = q{[} . (join q{, }, map {
                q{[} . $_->[0]->as_perl()
                    . q{, } . $_->[1]->as_perl() . q{]}
            } @{$self->{$ATTR_MAP_AOA}}) . q{]};
        $self->{$ATTR_AS_PERL}
            = "Muldis::DB::Literal::_TypeDict->new({ 'map' => $s })";
    }
    return $self->{$ATTR_AS_PERL};
}

###########################################################################

sub _equal_repr {
    my ($self, $other) = @_;
    return $BOOL_FALSE
        if @{$other->{$ATTR_MAP_AOA}} != @{$self->{$ATTR_MAP_AOA}};
    my $v1 = $self->{$ATTR_MAP_HOA};
    my $v2 = $other->{$ATTR_MAP_HOA};
    for my $ek (keys %{$v1}) {
        return $BOOL_FALSE
            if !exists $v2->{$ek};
        return $BOOL_FALSE
            if !$v1->{$ek}->[1]->equal_repr({
                'other' => $v2->[1]->{$ek} });
    }
    return $BOOL_TRUE;
}

###########################################################################

sub map {
    my ($self) = @_;
    return [map { [@{$_}] } @{$self->{$ATTR_MAP_AOA}}];
}

sub map_hoa {
    my ($self) = @_;
    my $h = $self->{$ATTR_MAP_HOA};
    return {map { $_ => [@{$h->{$_}}] } keys %{$h}};
}

###########################################################################

sub elem_count {
    my ($self) = @_;
    return 0 + @{$self->{$ATTR_MAP_AOA}};
}

sub elem_exists {
    my ($self, $args) = @_;
    my ($elem_name) = @{$args}{'elem_name'};

    confess q{elem_exists(): Bad :$elem_name arg; it is not an object of a}
            . q{ Muldis::DB::Literal::EntityName-doing class.}
        if !blessed $elem_name
            or !$elem_name->isa( 'Muldis::DB::Literal::EntityName' );

    return exists $self->{$ATTR_MAP_HOA}->{$elem_name->text()};
}

sub elem_value {
    my ($self, $args) = @_;
    my ($elem_name) = @{$args}{'elem_name'};

    confess q{elem_value(): Bad :$elem_name arg; it is not an object of a}
            . q{ Muldis::DB::Literal::EntityName-doing class.}
        if !blessed $elem_name
            or !$elem_name->isa( 'Muldis::DB::Literal::EntityName' );
    my $elem_name_text = $elem_name->text();

    confess q{elem_value(): Bad :$elem_name arg; it matches no dict elem.}
        if !exists $self->{$ATTR_MAP_HOA}->{$elem_name_text};

    return $self->{$ATTR_MAP_HOA}->{$elem_name_text};
}

###########################################################################

} # role Muldis::DB::Literal::_TypeDict

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::TypeDict; # class
    use base 'Muldis::DB::Literal::_TypeDict';
    sub _allows_quasi { return $BOOL_FALSE; }
} # class Muldis::DB::Literal::TypeDict

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::QuasiTypeDict; # class
    use base 'Muldis::DB::Literal::_TypeDict';
    sub _allows_quasi { return $BOOL_TRUE; }
} # class Muldis::DB::Literal::QuasiTypeDict

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::_ExprDict; # class
    use base 'Muldis::DB::Literal::Node';

    use Carp;
    use Scalar::Util qw(blessed);

    my $ATTR_MAP_AOA = 'map_aoa';
    my $ATTR_MAP_HOA = 'map_hoa';

    # Note: This type is specific such that values are always some ::Expr,
    # but this type may be later generalized to hold ::Node instead.

    my $ATTR_AS_PERL = 'as_perl';

###########################################################################

sub _build {
    my ($self, $args) = @_;
    my ($map) = @{$args}{'map'};

    confess q{new(): Bad :$map arg; it is not an Array.}
        if ref $map ne 'ARRAY';
    my $map_aoa = [];
    my $map_hoa = {};
    for my $elem (@{$map}) {
        confess q{new(): Bad :$map arg elem; it is not a 2-element Array.}
            if ref $elem ne 'ARRAY' or @{$elem} != 2;
        my ($entity_name, $expr) = @{$elem};
        confess q{new(): Bad :$map arg elem; its first elem is not an}
                . q{ object of a Muldis::DB::Literal::EntityName-doing class.}
            if !blessed $entity_name
                or !$entity_name->isa( 'Muldis::DB::Literal::EntityName' );
        my $entity_name_text = $entity_name->text();
        confess q{new(): Bad :$map arg elem; its first elem is not}
                . q{ distinct between the arg elems.}
            if exists $map_hoa->{$entity_name_text};
        confess q{new(): Bad :$map arg elem; its second elem is not}
                . q{ an object of a Muldis::DB::Literal::Expr-doing class.}
            if !blessed $expr or !$expr->isa( 'Muldis::DB::Literal::Expr' );
        my $elem_cpy = [$entity_name, $expr];
        push @{$map_aoa}, $elem_cpy;
        $map_hoa->{$entity_name_text} = $elem_cpy;
    }

    $self->{$ATTR_MAP_AOA} = $map_aoa;
    $self->{$ATTR_MAP_HOA} = $map_hoa;

    return;
}

###########################################################################

sub as_perl {
    my ($self) = @_;
    if (!defined $self->{$ATTR_AS_PERL}) {
        my $s = q{[} . (join q{, }, map {
                q{[} . $_->[0]->as_perl()
                    . q{, } . $_->[1]->as_perl() . q{]}
            } @{$self->{$ATTR_MAP_AOA}}) . q{]};
        $self->{$ATTR_AS_PERL}
            = "Muldis::DB::Literal::_ExprDict->new({ 'map' => $s })";
    }
    return $self->{$ATTR_AS_PERL};
}

###########################################################################

sub _equal_repr {
    my ($self, $other) = @_;
    return $BOOL_FALSE
        if @{$other->{$ATTR_MAP_AOA}} != @{$self->{$ATTR_MAP_AOA}};
    my $v1 = $self->{$ATTR_MAP_HOA};
    my $v2 = $other->{$ATTR_MAP_HOA};
    for my $ek (keys %{$v1}) {
        return $BOOL_FALSE
            if !exists $v2->{$ek};
        return $BOOL_FALSE
            if !$v1->{$ek}->[1]->equal_repr({
                'other' => $v2->[1]->{$ek} });
    }
    return $BOOL_TRUE;
}

###########################################################################

sub map {
    my ($self) = @_;
    return [map { [@{$_}] } @{$self->{$ATTR_MAP_AOA}}];
}

sub map_hoa {
    my ($self) = @_;
    my $h = $self->{$ATTR_MAP_HOA};
    return {map { $_ => [@{$h->{$_}}] } keys %{$h}};
}

###########################################################################

sub elem_count {
    my ($self) = @_;
    return 0 + @{$self->{$ATTR_MAP_AOA}};
}

sub elem_exists {
    my ($self, $args) = @_;
    my ($elem_name) = @{$args}{'elem_name'};

    confess q{elem_exists(): Bad :$elem_name arg; it is not an object of a}
            . q{ Muldis::DB::Literal::EntityName-doing class.}
        if !blessed $elem_name
            or !$elem_name->isa( 'Muldis::DB::Literal::EntityName' );

    return exists $self->{$ATTR_MAP_HOA}->{$elem_name->text()};
}

sub elem_value {
    my ($self, $args) = @_;
    my ($elem_name) = @{$args}{'elem_name'};

    confess q{elem_value(): Bad :$elem_name arg; it is not an object of a}
            . q{ Muldis::DB::Literal::EntityName-doing class.}
        if !blessed $elem_name
            or !$elem_name->isa( 'Muldis::DB::Literal::EntityName' );
    my $elem_name_text = $elem_name->text();

    confess q{elem_value(): Bad :$elem_name arg; it matches no dict elem.}
        if !exists $self->{$ATTR_MAP_HOA}->{$elem_name_text};

    return $self->{$ATTR_MAP_HOA}->{$elem_name_text};
}

###########################################################################

} # class Muldis::DB::Literal::_ExprDict

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::FuncDecl; # class
    use base 'Muldis::DB::Literal::Node';

    use Carp;
    use Scalar::Util qw(blessed);

###########################################################################

sub _build {
    confess q{not implemented};
}

###########################################################################

} # class Muldis::DB::Literal::FuncDecl

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::ProcDecl; # class
    use base 'Muldis::DB::Literal::Node';

    use Carp;
    use Scalar::Util qw(blessed);

###########################################################################

sub _build {
    confess q{not implemented};
}

###########################################################################

} # class Muldis::DB::Literal::ProcDecl

###########################################################################
###########################################################################

{ package Muldis::DB::Literal::HostGateRtn; # class
    use base 'Muldis::DB::Literal::Node';

    use Carp;
    use Scalar::Util qw(blessed);

    my $ATTR_UPD_PARAMS = 'upd_params';
    my $ATTR_RO_PARAMS  = 'ro_params';
    my $ATTR_VARS       = 'vars';
    my $ATTR_STMTS      = 'stmts';

    my $ATTR_AS_PERL = 'as_perl';

    my $TYPEDICT_ATTR_MAP_HOA = 'map_hoa';

###########################################################################

sub _build {
    my ($self, $args) = @_;
    my ($upd_params, $ro_params, $vars, $stmts)
        = @{$args}{'upd_params', 'ro_params', 'vars', 'stmts'};

    confess q{new(): Bad :$upd_params arg; it is not a valid object}
            . q{ of a Muldis::DB::Literal::_TypeDict-doing class.}
        if !blessed $upd_params
            or !$upd_params->isa( 'Muldis::DB::Literal::_TypeDict' );
    confess q{new(): Bad :$ro_params arg; it is not a valid object}
            . q{ of a Muldis::DB::Literal::_TypeDict-doing class.}
        if !blessed $ro_params
            or !$ro_params->isa( 'Muldis::DB::Literal::_TypeDict' );
    my $upd_params_map_hoa = $upd_params->{$TYPEDICT_ATTR_MAP_HOA};
    confess q{new(): Bad :$upd_params or :$ro_params arg;}
            . q{ they both reference at least 1 same stmtsedure param.}
        if grep {
                exists $upd_params_map_hoa->{$_}
            } keys %{$ro_params->{$TYPEDICT_ATTR_MAP_HOA}};

    confess q{new(): Bad :$vars arg; it is not a valid object}
            . q{ of a Muldis::DB::Literal::_TypeDict-doing class.}
        if !blessed $vars or !$vars->isa( 'Muldis::DB::Literal::_TypeDict' );

    confess q{new(): Bad :$stmts arg; it is not an Array.}
        if ref $stmts ne 'ARRAY';
    for my $stmt (@{$stmts}) {
        confess q{new(): Bad :$stmts arg elem; it is not}
                . q{ an object of a Muldis::DB::Literal::Stmt-doing class.}
            if !blessed $stmt or !$stmt->isa( 'Muldis::DB::Literal::Stmt' );
    }

    $self->{$ATTR_UPD_PARAMS} = $upd_params;
    $self->{$ATTR_RO_PARAMS}  = $ro_params;
    $self->{$ATTR_VARS}       = $vars;
    $self->{$ATTR_STMTS}      = [@{$stmts}];

    return;
}

###########################################################################

sub as_perl {
    my ($self) = @_;
    if (!defined $self->{$ATTR_AS_PERL}) {
        my $sup = $self->{$ATTR_UPD_PARAMS}->as_perl();
        my $srp = $self->{$ATTR_RO_PARAMS}->as_perl();
        my $sv = $self->{$ATTR_VARS}->as_perl();
        my $ss = q{[} . (join q{, }, map {
                $_->as_perl()
            } @{$self->{$ATTR_STMTS}}) . q{]};
        $self->{$ATTR_AS_PERL} = "Muldis::DB::Literal::HostGateRtn->new({"
            . " 'upd_params' => $sup, 'ro_params' => $srp"
            . ", 'vars' => $sv, 'stmts' => $ss })";
    }
    return $self->{$ATTR_AS_PERL};
}

###########################################################################

sub _equal_repr {
    my ($self, $other) = @_;
    return $BOOL_FALSE
        if !$self->{$ATTR_UPD_PARAMS}->equal_repr({
                'other' => $other->{$ATTR_UPD_PARAMS} })
            or !$self->{$ATTR_RO_PARAMS}->equal_repr({
                'other' => $other->{$ATTR_RO_PARAMS} })
            or !$self->{$ATTR_VARS}->equal_repr({
                'other' => $other->{$ATTR_VARS} });
    my $v1 = $self->{$ATTR_STMTS};
    my $v2 = $other->{$ATTR_STMTS};
    return $BOOL_FALSE
        if @{$v2} != @{$v1};
    for my $i (0..$#{$v1}) {
        return $BOOL_FALSE
            if !$v1->[$i]->equal_repr({ 'other' => $v2->[$i] });
    }
    return $BOOL_TRUE;
}

###########################################################################

sub upd_params {
    my ($self) = @_;
    return $self->{$ATTR_UPD_PARAMS};
}

sub ro_params {
    my ($self) = @_;
    return $self->{$ATTR_RO_PARAMS};
}

sub vars {
    my ($self) = @_;
    return $self->{$ATTR_VARS};
}

sub stmts {
    my ($self) = @_;
    return [@{$self->{$ATTR_STMTS}}];
}

###########################################################################

} # class Muldis::DB::Literal::HostGateRtn

###########################################################################
###########################################################################

1; # Magic true value required at end of a reusable file's code.
__END__

=pod

=encoding utf8

=head1 NAME

Muldis::DB::Literal -
Abstract syntax tree for the Muldis D language

=head1 VERSION

This document describes Muldis::DB::Literal version 0.3.0 for Perl 5.

It also describes the same-number versions for Perl 5 of [...].

=head1 SYNOPSIS

I<This documentation is pending.>

    use Muldis::DB::Literal;

    my $truth_value = Muldis::DB::Literal::Bool->new({ 'v' => (2 + 2 == 4) });
    my $direction = Muldis::DB::Literal::Order->new({ 'v' => (5 <=> 7) });
    my $answer = Muldis::DB::Literal::Int->new({ 'v' => 42 });
    my $package = Muldis::DB::Literal::Blob->new({ 'v' => (pack 'H2', 'P') });
    my $planetoid = Muldis::DB::Literal::Text->new({ 'v' => 'Ceres' });

I<This documentation is pending.>

=head1 DESCRIPTION

The native command language of a L<Muldis::DB> DBMS (database management
system) / virtual machine is called B<Muldis D>; see
L<Language::MuldisD> for the language's human readable authoritative
design document.

This library, Muldis::DB::Literal ("AST"), provides a few dozen container
classes which collectively implement the I<Abstract> representation format
of Muldis D; each class is called an I<AST node type> or I<node type>, and
an object of one of these classes is called an I<AST node> or I<node>.

These are all of the roles and classes that Muldis::DB::Literal defines (more
will be added in the future), which are visually arranged here in their
"does" or "isa" hierarchy, children indented under parents:

    Muldis::DB::Literal::Node (dummy role)
        Muldis::DB::Literal::Expr (dummy role)
            Muldis::DB::Literal::Lit (dummy role)
                Muldis::DB::Literal::Bool
                Muldis::DB::Literal::Order
                Muldis::DB::Literal::Int
                Muldis::DB::Literal::Blob
                Muldis::DB::Literal::Text
            Muldis::DB::Literal::_Tuple (implementing role)
                Muldis::DB::Literal::Tuple
                Muldis::DB::Literal::QuasiTuple
            Muldis::DB::Literal::_Relation (implementing role)
                Muldis::DB::Literal::Relation
                Muldis::DB::Literal::QuasiRelation
            Muldis::DB::Literal::Default
            Muldis::DB::Literal::Treat
            Muldis::DB::Literal::VarInvo
            Muldis::DB::Literal::FuncInvo
        Muldis::DB::Literal::Stmt (dummy role)
            Muldis::DB::Literal::ProcInvo
            Muldis::DB::Literal::FuncReturn
            Muldis::DB::Literal::ProcReturn
            # more control-flow statement types would go here
        Muldis::DB::Literal::EntityName
        Muldis::DB::Literal::_TypeInvo (implementing role)
            Muldis::DB::Literal::TypeInvo
            Muldis::DB::Literal::QuasiTypeInvo
        Muldis::DB::Literal::_TypeDict (implementing role)
            Muldis::DB::Literal::TypeDict
            Muldis::DB::Literal::QuasiTypeDict
        Muldis::DB::Literal::_ExprDict
        Muldis::DB::Literal::FuncDecl
        Muldis::DB::Literal::ProcDecl
        # more routine declaration types would go here
        Muldis::DB::Literal::HostGateRtn

All Muldis D abstract syntax trees are such in the compositional sense;
that is, every AST node is composed primarily of zero or more other AST
nodes, and so a node is a child of another iff the former is composed into
the latter.  All AST nodes are immutable objects; their values are
determined at construction time, and they can't be changed afterwards.
Therefore, constructing a tree is a bottom-up process, such that all child
objects have to be constructed prior to, and be passed in as constructor
arguments of, their parents.  The process is like declaring an entire
multi-dimensional Perl data structure at the time the variable holding it
is declared; the data structure is actually built from the inside to the
outside.  A consequence of the immutability is that it is feasible to
reuse AST nodes many times, since they won't change out from under you.

An AST node denotes an arbitrarily complex value, that value being defined
by the type of the node and what its attributes are (some of which are
themselves nodes, and some of which aren't).  A node can denote either a
scalar value, or a collection value, or an expression that would evaluate
into a value, or a statement or routine definition that could be later
executed to either return a value or have some side effect.  For all
intents and purposes, a node is a program, and can represent anything that
program code can represent, both values and actions.

The Muldis::DB framework uses Muldis::DB AST nodes for the dual purpose of
defining routines to execute and defining values to use as arguments to and
return values from the execution of said routines.  The C<prepare()> method
of a C<Muldis::DB::Interface::DBMS> object, and by extension the
C<Muldis::DB::Interface::HostGateRtn->new()> constructor function, takes a
C<Muldis::DB::Literal::HostGateRtn> node as its primary argument, such that the
AST object defines the source code that is compiled to become the Interface
object.  The C<fetch_ast()> and C<store_ast()> methods of a
C<Muldis::DB::Interface::HostGateVar> object will get or set that object's
primary value attribute, which is any C<Muldis::DB::Literal::Node>.  The C<Var>
objects are bound to C<Rtn> objects, and they are the means by which an
executed routine accepts input or provides output at C<execute()> time.

=head2 AST Node Values Versus Representations

In the general case, Muldis::DB AST nodes do not maintain canonical
representations of all Muldis D values, meaning that it is possible and
common to have 2 given AST nodes that logically denote the same value, but
they have different actual compositions.  (Some node types are special
cases for which the aforementioned isn't true; see below.)

For example, a node whose value is just the number 5 can have any number of
representations, each of which is an expression that evaluates to the
number 5 (such as [C<5>, C<2+3>, C<10/2>]).  Another example is a node
whose value is the set C<{3,5,7}>; it can be represented, for example,
either by C<Set(5,3,7,7,7)> or C<Union(Set(3,5),Set(5,7))> or
C<Set(7,5,3)>.  I<These examples aren't actual Muldis::DB AST syntax.>

For various reasons, the Muldis::DB::Literal classes themselves do not do any
node refactoring, and their representations differ little if any from the
format of their constructor arguments, which can contain extra information
that is not logically significant in determining the node value.  One
reason is that this allows a semblance of maintaining the actual syntax
that the user specified, which is useful for their debugging purposes.
Another reason is the desire to keep this library as light-weight as
possible, such that it just implements the essentials; doing refactoring
can require a code size and complexity that is orders of magnitude larger
than these essentials, and that work isn't always helpful.  It should also
be noted that any nodes having references to externally user-defined
entities can't be fully refactored as each of those represents a free
variable that a static node analysis can't decompose; only nodes consisting
of just system-defined or literal entities (meaning zero free variables)
can be fully refactored in a static node analysis (though there are a fair
number of those in practice, particularly as C<Var> values).

A consequence of this is that the Muldis::DB::Literal classes in general do not
include do not include any methods for comparing that 2 nodes denote the
same value; to reliably do that, you will have to use means not provided by
this library.  However, each class I<does> provide a C<equal_repr> method,
which compares that 2 nodes have the same representation.

It should be noted that a serialize/unserialize cycle on a node that is
done using the C<as_perl> routine to serialize, and having Perl eval that
to unserialize, is guaranteed to preserve the representation, so
C<equal_repr> will work as expected in that situation.

As an exception to the general case about nodes, the node classes
[C<BoolLit>, C<TextLit>, C<BlobLit>, C<IntLit>, C<EntityName>, C<VarInvo>,
C<ProcReturn>] are guaranteed to only ever have a single representation per
value, and so C<equal_repr> is guaranteed to indicate value equality of 2
nodes of those types.  In fact, to assist the consequence this point, these
node classes also have the C<equal_value> method which is an alias for
C<equal_repr>, so you can use C<equal_value> in your use code to make it
better self documenting; C<equal_repr> is still available for all node
types to assist automated use code that wants to treat all node types the
same.  It should also be noted that a C<BoolLit> node can only possibly be
of one of 2 values, and C<ProcReturn> is a singleton.

It is expected that multiple third party utility modules will become
available over time whose purpose is to refactor a Muldis::DB AST node,
either as part of a static analysis that considers only the node in
isolation (and any user-defined entity references have to be treated as
free variables and not generally be factored out), or as part of an Engine
implementation that also considers the current virtual machine environment
and what user-defined entities exist there (and depending on the context,
user-defined entity references don't have to be free variables).

=head1 INTERFACE

The interface of Muldis::DB::Literal is fundamentally object-oriented; you use
it by creating objects from its member classes, usually invoking C<new()>
on the appropriate class name, and then invoking methods on those objects.
All of their attributes are private, so you must use accessor methods.

Muldis::DB::Literal also provides wrapper subroutines for all member class
constructors, 1 per each, where each subroutine has identical parameters to
the constructor it wraps, and the name of each subroutine is equal to the
trailing part of the class name, specifically the C<Foo> of
C<Muldis::DB::Literal::Foo>, but with a C<new> prefix (so that Perl doesn't
confuse a fully-qualified sub name with a class name).  All of these
subroutines are exportable, but are not exported by default, and exist
solely as syntactic sugar to allow user code to have more brevity.  I<TODO:
Reimplement these as lexical aliases or compile-time macros instead, to
avoid the overhead of extra routine calls.>

The usual way that Muldis::DB::Literal indicates a failure is to throw an
exception; most often this is due to invalid input.  If an invoked routine
simply returns, you can assume that it has succeeded, even if the return
value is undefined.

=head2 The Muldis::DB::Literal::Bool Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::Order Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::Int Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::Blob Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::Text Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::Tuple Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::QuasiTuple Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::Relation Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::QuasiRelation Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::Default Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::Treat Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::VarInvo Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::FuncInvo Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::ProcInvo Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::FuncReturn Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::ProcReturn Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::EntityName Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::TypeInvo Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::QuasiTypeInvo Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::TypeDict Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::QuasiTypeDict Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::_ExprDict Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::FuncDecl Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::ProcDecl Class

I<This documentation is pending.>

=head2 The Muldis::DB::Literal::HostGateRtn Class

I<This documentation is pending.>

=head1 DIAGNOSTICS

I<This documentation is pending.>

=head1 CONFIGURATION AND ENVIRONMENT

I<This documentation is pending.>

=head1 DEPENDENCIES

This file requires any version of Perl 5.x.y that is at least 5.8.1.

=head1 INCOMPATIBILITIES

None reported.

=head1 SEE ALSO

Go to L<Muldis::DB> for the majority of distribution-internal references,
and L<Muldis::DB::SeeAlso> for the majority of distribution-external
references.

=head1 BUGS AND LIMITATIONS

For design simplicity in the short term, all AST arguments that are
applicable must be explicitly defined by the user, even if it might be
reasonable for Muldis::DB to figure out a default value for them, such as
"same as self".  This limitation will probably be removed in the future.
All that said, a few arguments may be exempted from this limitation.

I<This documentation is pending.>

=head1 AUTHOR

Darren Duncan (C<perl@DarrenDuncan.net>)

=head1 LICENSE AND COPYRIGHT

This file is part of the Muldis::DB framework.

Muldis::DB is Copyright © 2002-2007, Darren Duncan.

See the LICENSE AND COPYRIGHT of L<Muldis::DB> for details.

=head1 ACKNOWLEDGEMENTS

The ACKNOWLEDGEMENTS in L<Muldis::DB> apply to this file too.

=cut
