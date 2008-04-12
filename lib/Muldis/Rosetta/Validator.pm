use 5.008001;
use utf8;
use strict;
use warnings FATAL => 'all';

use Muldis::DB::Interface;

###########################################################################
###########################################################################

{ package Muldis::DB::Validator; # module
    use version; our $VERSION = qv('0.6.2');

    use Test::More;

###########################################################################

sub main {
    my ($args) = @_;
    my ($engine_name, $machine_config)
        = @{$args}{'engine_name', 'machine_config'};

    plan( 'tests' => 13 );

    print
        "#### Muldis::DB::Validator starting test of $engine_name ####\n";

    # Instantiate a Muldis DB DBMS / virtual machine.
    my $machine = Muldis::DB::Interface::new_machine({
        'engine_name' => $engine_name,
        'exp_ast_lang' => [ 'Muldis_D', 'http://muldis.com', '0.25.0' ],
        'machine_config' => $machine_config,
    });
    does_ok( $machine, 'Muldis::DB::Interface::Machine' );
    my $process = $machine->new_process();
    does_ok( $process, 'Muldis::DB::Interface::Process' );

    _scenario_foods_suppliers_shipments_v1( $process );

    print
        "#### Muldis::DB::Validator finished test of $engine_name ####\n";

    return;
}

###########################################################################

sub _scenario_foods_suppliers_shipments_v1 {
    my ($process) = @_;

    # Declare our Perl-lexical variables to use for source data.

    my $src_suppliers = $process->new_var({
        'decl_type' => 'sys.Core.Relation.Relation' });
    does_ok( $src_suppliers, 'Muldis::DB::Interface::Var' );
    my $src_foods = $process->new_var({
        'decl_type' => 'sys.Core.Relation.Relation' });
    does_ok( $src_foods, 'Muldis::DB::Interface::Var' );
    my $src_shipments = $process->new_var({
        'decl_type' => 'sys.Core.Relation.Relation' });
    does_ok( $src_shipments, 'Muldis::DB::Interface::Var' );

    # Load our example literal source data sets into said Perl-lexicals.

    $src_suppliers->store_ast({
        'ast' => [ 'Relation', 'sys.Core.Relation.Relation', [
            {
                'farm'    => [ 'NEText', 'Hodgesons' ],
                'country' => [ 'NEText', 'Canada' ],
            },
            {
                'farm'    => [ 'NEText', 'Beckers' ],
                'country' => [ 'NEText', 'England' ],
            },
            {
                'farm'    => [ 'NEText', 'Wickets' ],
                'country' => [ 'NEText', 'Canada' ],
            },
        ] ],
    });
    pass( 'no death from loading example suppliers data into VM' );

    $src_foods->store_ast({
        'ast' => [ 'Relation', 'sys.Core.Relation.Relation', [
            {
                'food'   => [ 'NEText', 'Bananas' ],
                'colour' => [ 'NEText', 'yellow' ],
            },
            {
                'food'   => [ 'NEText', 'Carrots' ],
                'colour' => [ 'NEText', 'orange' ],
            },
            {
                'food'   => [ 'NEText', 'Oranges' ],
                'colour' => [ 'NEText', 'orange' ],
            },
            {
                'food'   => [ 'NEText', 'Kiwis' ],
                'colour' => [ 'NEText', 'green' ],
            },
            {
                'food'   => [ 'NEText', 'Lemons' ],
                'colour' => [ 'NEText', 'yellow' ],
            },
        ] ],
    });
    pass( 'no death from loading example foods data into VM' );

    $src_shipments->store_ast({
        'ast' => [ 'Relation', 'sys.Core.Relation.Relation', [
            {
                'farm' => [ 'NEText', 'Hodgesons' ],
                'food' => [ 'NEText', 'Kiwis' ],
                'qty'  => [ 'PInt', 'perl_pint', 100 ],
            },
            {
                'farm' => [ 'NEText', 'Hodgesons' ],
                'food' => [ 'NEText', 'Lemons' ],
                'qty'  => [ 'PInt', 'perl_pint', 130 ],
            },
            {
                'farm' => [ 'NEText', 'Hodgesons' ],
                'food' => [ 'NEText', 'Oranges' ],
                'qty'  => [ 'PInt', 'perl_pint', 10 ],
            },
            {
                'farm' => [ 'NEText', 'Hodgesons' ],
                'food' => [ 'NEText', 'Carrots' ],
                'qty'  => [ 'PInt', 'perl_pint', 50 ],
            },
            {
                'farm' => [ 'NEText', 'Beckers' ],
                'food' => [ 'NEText', 'Carrots' ],
                'qty'  => [ 'PInt', 'perl_pint', 90 ],
            },
            {
                'farm' => [ 'NEText', 'Beckers' ],
                'food' => [ 'NEText', 'Bananas' ],
                'qty'  => [ 'PInt', 'perl_pint', 120 ],
            },
            {
                'farm' => [ 'NEText', 'Wickets' ],
                'food' => [ 'NEText', 'Lemons' ],
                'qty'  => [ 'PInt', 'perl_pint', 30 ],
            },
        ] ],
    });
    pass( 'no death from loading example shipments data into VM' );

    # Execute a query against the virtual machine, to look at our sample
    # data and see what suppliers there are for foods coloured 'orange'.

    my $desi_colour
        = $process->new_var({ 'decl_type' => 'sys.Core.Text.Text' });
    does_ok( $desi_colour, 'Muldis::DB::Interface::Var' );
    $desi_colour->store_ast({ 'ast' => [ 'NEText', 'orange' ] });
    pass( 'no death from loading desired colour into VM' );

    my $matched_suppl = $process->call_func({
        'func_name' => 'sys.Core.Relation.semijoin',
        'args' => {
            'source' => $src_suppliers,
            'filter' => $process->call_func({
                'func_name' => 'sys.Core.Relation.join',
                'args' => {
                    'topic' => [ 'QuasiSet',
                            'sys.Core.Spec.QuasiSetOfRelation', [
                        $src_shipments,
                        $src_foods,
                        [ 'Relation', 'sys.Core.Relation.Relation', [
                            {
                                'colour' => $desi_colour,
                            },
                        ] ],
                    ] ],
                },
            }),
        },
    });
    pass( 'no death from executing search query' );
    does_ok( $matched_suppl, 'Muldis::DB::Interface::Var' );

    my $matched_suppl_ast = $matched_suppl->fetch_ast();
    pass( 'no death from fetching search results from VM' );

    # Finally, use the result somehow (not done here).
    # The result should be:
    # [ 'Relation', 'sys.Core.Relation.Relation', [
    #     {
    #         'farm'    => [ 'NEText', 'Hodgesons' ],
    #         'country' => [ 'NEText', 'Canada' ],
    #     },
    #     {
    #         'farm'    => [ 'NEText', 'Beckers' ],
    #         'country' => [ 'NEText', 'England' ],
    #     },
    # ] ]

    print "# debug: orange food suppliers found:\n";
#    print "# " . $rel_def_matched_suppl->as_perl() . "\n";
    print "#  TODO, as_perl()\n";

    return;
}

###########################################################################

# This does_ok exists for code parity with the Perl 6 Validator.pm, where
# a does_ok is a modified clone of Test.pm's isa_ok, that tests using
# .does rather than .isa; in Perl 5, they mean the same thing.

*does_ok = \&isa_ok;

###########################################################################

} # module Muldis::DB::Validator

###########################################################################
###########################################################################

1; # Magic true value required at end of a reusable file's code.
__END__

=pod

=encoding utf8

=head1 NAME

Muldis::DB::Validator -
A common comprehensive test suite to run against all Engines

=head1 VERSION

This document describes Muldis::DB::Validator version 0.6.2 for Perl 5.

=head1 SYNOPSIS

This can be the complete content of the main C<t/*.t> file for an example
Muldis::DB Engine distribution:

    use 5.008001;
    use utf8;
    use strict;
    use warnings FATAL => 'all';

    # Load the test suite.
    use Muldis::DB::Validator;

    # Run the test suite.
    Muldis::DB::Validator::main({
        'engine_name' => 'Muldis::DB::Engine::Example',
        'machine_config' => {},
    });

    1;

The current release of Muldis::DB::Validator uses L<Test::More> internally,
and C<main()> will invoke it to output what the standard Perl test harness
expects.  I<It is expected that this will change in the future so that
Validator does not use Test::More internally, and rather will simply return
test results in a data structure that the main t/*.t then can disseminate
and pass the components to Test::More itself.>

=head1 DESCRIPTION

The Muldis::DB::Validator Perl 5 module is a common comprehensive test
suite to run against all Muldis DB Engines.  You run it against a
Muldis DB Engine module to ensure that the Engine and/or the database
behind it implements the parts of the Muldis DB API that your application
needs, and that the API is implemented correctly.  Muldis::DB::Validator is
intended to guarantee a measure of quality assurance (QA) for Muldis::DB,
so your application can use the database access framework with confidence
of safety.

Alternately, if you are writing a Muldis DB Engine module yourself,
Muldis::DB::Validator saves you the work of having to write your own test
suite for it.  You can also be assured that if your module passes
Muldis::DB::Validator's approval, then your module can be easily swapped in
for other Engine modules by your users, and that any changes you make
between releases haven't broken something important.

Muldis::DB::Validator would be used similarly to how Sun has an official
validation suite for Java Virtual Machines to make sure they implement the
official Java specification.

For reference and context, please see the FEATURE SUPPORT VALIDATION
documentation section in the core L<Muldis::DB> module.

Note that, as is the nature of test suites, Muldis::DB::Validator will be
getting regular updates and additions, so that it anticipates all of the
different ways that people want to use their databases.  This task is
unlikely to ever be finished, given the seemingly infinite size of the
task.  You are welcome and encouraged to submit more tests to be included
in this suite at any time, as holes in coverage are discovered.

I<This documentation is pending.>

=head1 INTERFACE

I<This documentation is pending; this section may also be split into
several.>

=head1 DIAGNOSTICS

I<This documentation is pending.>

=head1 CONFIGURATION AND ENVIRONMENT

I<This documentation is pending.>

=head1 DEPENDENCIES

This file requires any version of Perl 5.x.y that is at least 5.8.1, and
recommends one that is at least 5.10.0.

It also requires these Perl 5 packages that are bundled with any version of
Perl 5.x.y that is at least 5.10.0, and are also on CPAN for separate
installation by users of earlier Perl versions: L<version>.

It also requires these Perl 5 classes that are in the current distribution:
L<Muldis::DB::Interface-0.6.2|Muldis::DB::Interface>.

=head1 INCOMPATIBILITIES

None reported.

=head1 SEE ALSO

Go to L<Muldis::DB> for the majority of distribution-internal references,
and L<Muldis::DB::SeeAlso> for the majority of distribution-external
references.

=head1 BUGS AND LIMITATIONS

I<This documentation is pending.>

=head1 AUTHOR

Darren Duncan (C<perl@DarrenDuncan.net>)

=head1 LICENSE AND COPYRIGHT

This file is part of the Muldis DB framework.

Muldis DB is Copyright © 2002-2008, Darren Duncan.

See the LICENSE AND COPYRIGHT of L<Muldis::DB> for details.

=head1 TRADEMARK POLICY

The TRADEMARK POLICY in L<Muldis::DB> applies to this file too.

=head1 ACKNOWLEDGEMENTS

The ACKNOWLEDGEMENTS in L<Muldis::DB> apply to this file too.

=cut
