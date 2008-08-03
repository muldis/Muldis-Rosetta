use 5.008001;
use utf8;
use strict;
use warnings FATAL => 'all';

###########################################################################
###########################################################################

{ package Muldis::Rosetta::Interface; # module
    use version; our $VERSION = qv('0.7.0');
    # Note: This given version applies to all of this file's packages.

    use Carp;
    use Encode qw(is_utf8);
    use Scalar::Util qw(blessed);

###########################################################################

sub new_machine {
    my ($args) = @_;
    my ($engine_name, $machine_config)
        = @{$args}{'engine_name', 'machine_config'};

    confess q{new_machine(): Bad :$engine_name arg; Perl 5 does not}
            . q{ consider it to be a character str, or it's the empty str.}
        if !defined $engine_name or $engine_name eq q{}
            or (!is_utf8 $engine_name
                and $engine_name =~ m/[^\x00-\x7F]/xs);

    # A module may be loaded due to it being embedded in a non-excl file.
    if (!do {
            no strict 'refs';
            defined %{$engine_name . '::'};
        }) {
        # Note: We have to invoke this 'require' in an eval string
        # because we need the bareword semantics, where 'require'
        # will munge the module name into file system paths.
        eval "require $engine_name;";
        if (my $err = $@) {
            confess q{new_machine(): Could not load Muldis Rosetta Engine}
                . qq{ module '$engine_name': $err};
        }
        confess qq{new_machine(): Could not load Muldis Rosetta Engine mod}
                . qq{ '$engine_name': while that file did compile without}
                . q{ errors, it did not declare the same-named module.}
            if !do {
                no strict 'refs';
                defined %{$engine_name . '::'};
            };
    }
    confess qq{new_machine(): The Muldis Rosetta Engine mod '$engine_name'}
            . q{ does not provide the new_machine() constructor function.}
        if !$engine_name->can( 'new_machine' );
    my $machine = eval {
        &{$engine_name->can( 'new_machine' )}({
            'machine_config' => $machine_config });
    };
    if (my $err = $@) {
        confess qq{new_machine(): Th Muldis Rosetta Eng mod '$engine_name'}
            . qq{ threw an exception during its new_machine() exec: $err};
    }
    confess q{new_machine(): The new_machine() constructor function of the}
            . qq{ Muldis Rosetta Engine mod '$engine_name' did not ret an}
            . q{ obj of a Muldis::Rosetta::Interface::Machine-doing class.}
        if !blessed $machine
            or !$machine->isa( 'Muldis::Rosetta::Interface::Machine' );

    return $machine;
}

###########################################################################

} # module Muldis::Rosetta::Interface

###########################################################################
###########################################################################

{ package Muldis::Rosetta::Interface::Machine; # role
    use Carp;
    use Scalar::Util qw(blessed);

    sub new_process {
        my ($self) = @_;
        confess q{not implemented by subclass } . (blessed $self);
    }

    sub assoc_processes {
        my ($self) = @_;
        confess q{not implemented by subclass } . (blessed $self);
    }

} # role Muldis::Rosetta::Interface::Machine

###########################################################################
###########################################################################

{ package Muldis::Rosetta::Interface::Process; # role
    use Carp;
    use Scalar::Util qw(blessed);

    sub assoc_machine {
        my ($self) = @_;
        confess q{not implemented by subclass } . (blessed $self);
    }

    sub command_lang {
        my ($self) = @_;
        confess q{not implemented by subclass } . (blessed $self);
    }

    sub update_command_lang {
        my ($self) = @_;
        confess q{not implemented by subclass } . (blessed $self);
    }

    sub new_value {
        my ($self) = @_;
        confess q{not implemented by subclass } . (blessed $self);
    }

    sub assoc_values {
        my ($self) = @_;
        confess q{not implemented by subclass } . (blessed $self);
    }

    sub func_invo {
        my ($self) = @_;
        confess q{not implemented by subclass } . (blessed $self);
    }

    sub upd_invo {
        my ($self) = @_;
        confess q{not implemented by subclass } . (blessed $self);
    }

    sub proc_invo {
        my ($self) = @_;
        confess q{not implemented by subclass } . (blessed $self);
    }

    sub trans_nest_level {
        my ($self) = @_;
        confess q{not implemented by subclass } . (blessed $self);
    }

    sub start_trans {
        my ($self) = @_;
        confess q{not implemented by subclass } . (blessed $self);
    }

    sub commit_trans {
        my ($self) = @_;
        confess q{not implemented by subclass } . (blessed $self);
    }

    sub rollback_trans {
        my ($self) = @_;
        confess q{not implemented by subclass } . (blessed $self);
    }

} # role Muldis::Rosetta::Interface::Process

###########################################################################
###########################################################################

{ package Muldis::Rosetta::Interface::Value; # role
    use Carp;
    use Scalar::Util qw(blessed);

    sub assoc_process {
        my ($self) = @_;
        confess q{not implemented by subclass } . (blessed $self);
    }

    sub decl_type {
        my ($self) = @_;
        confess q{not implemented by subclass } . (blessed $self);
    }

    sub fetch_ast {
        my ($self) = @_;
        confess q{not implemented by subclass } . (blessed $self);
    }

    sub store_ast {
        my ($self) = @_;
        confess q{not implemented by subclass } . (blessed $self);
    }

} # role Muldis::Rosetta::Interface::Value

###########################################################################
###########################################################################

1; # Magic true value required at end of a reusable file's code.
__END__

=pod

=encoding utf8

=head1 NAME

Muldis::Rosetta::Interface -
Common public API for Muldis Rosetta Engines

=head1 VERSION

This document describes Muldis::Rosetta::Interface version 0.7.0 for Perl
5.

It also describes the same-number versions for Perl 5 of
Muldis::Rosetta::Interface::Machine ("Machine"),
Muldis::Rosetta::Interface::Process ("Process"),
Muldis::Rosetta::Interface::Value ("Value").

=head1 SYNOPSIS

This simple example declares two Perl variables containing relation data,
then does a (N-ary) relational join (natural inner join) on them, producing
a third Perl variable holding the relation data of the result.

    use Muldis::Rosetta::Interface;

    my $machine = Muldis::Rosetta::Interface::new_machine({
        'engine_name' => 'Muldis::Rosetta::Engine::Example' });
    my $process = $machine->new_process();
    $process->update_command_lang({ 'lang' => [ 'Muldis_D',
        'http://muldis.com', '0.43.0', 'HDMD_Perl_Tiny', {} ] });

    my $r1 = $process->new_value({
        'decl_type' => 'sys.std.Core.Type.Relation' });
    my $r2 = $process->new_value({
        'decl_type' => 'sys.std.Core.Type.Relation' });

    $r1->store_ast({ 'ast' => [ 'Relation', 'sys.std.Core.Type.Relation', [
        {
            'x' => [ 'PInt', 'perl_pint', 4 ],
            'y' => [ 'PInt', 'perl_pint', 7 ],
        },
        {
            'x' => [ 'PInt', 'perl_pint', 3 ],
            'y' => [ 'PInt', 'perl_pint', 2 ],
        },
    ] ] });

    $r2->store_ast({ 'ast' => [ 'Relation', 'sys.std.Core.Type.Relation', [
        {
            'y' => [ 'PInt', 'perl_pint', 5 ],
            'z' => [ 'PInt', 'perl_pint', 6 ],
        },
        {
            'y' => [ 'PInt', 'perl_pint', 2 ],
            'z' => [ 'PInt', 'perl_pint', 1 ],
        },
        {
            'y' => [ 'PInt', 'perl_pint', 2 ],
            'z' => [ 'PInt', 'perl_pint', 4 ],
        },
    ] ] });

    my $r3 = $process->func_invo({
        'function' => 'sys.std.Core.Relation.join',
        'args' => {
            'topic' => [ 'QuasiSet', 'quasi_set_of.sys.std.Core.Type.Relation', [
                $r1,
                $r2,
            ] ],
        }
    });

    my $r3_ast = $r3->fetch_ast();

    # Then $r3_ast contains:
    # [ 'Relation', 'sys.std.Core.Type.Relation', [
    #     {
    #         'x' => [ 'PInt', 'perl_pint', 3 ],
    #         'y' => [ 'PInt', 'perl_pint', 2 ],
    #         'z' => [ 'PInt', 'perl_pint', 1 ],
    #     },
    #     {
    #         'x' => [ 'PInt', 'perl_pint', 3 ],
    #         'y' => [ 'PInt', 'perl_pint', 2 ],
    #         'z' => [ 'PInt', 'perl_pint', 4 ],
    #     },
    # ] ]

For most examples of using Muldis Rosetta, and tutorials, please see the
separate L<Muldis::Rosetta::Cookbook> distribution (when that comes to
exist).

=head1 DESCRIPTION

B<Muldis::Rosetta::Interface>, aka I<Interface>, comprises the minimal core
of the Muldis Rosetta framework, the one component that probably every
program would use.  Together with the Muldis D language (see L<Muldis::D>),
it defines the common API for Muldis Rosetta implementations to do and
which applications invoke.

I<This documentation is pending.>

=head1 INTERFACE

The interface of Muldis::Rosetta::Interface is fundamentally
object-oriented; you use it by creating objects from its member classes (or
more specifically, of implementing subclasses of its member roles) and then
invoking methods on those objects.  All of their attributes are private, so
you must use accessor methods.

To aid portability of your applications over multiple implementing Engines,
the normal way to create Interface objects is by invoking a
constructor-wrapping method of some other object that would provide context
for it; since you generally don't have to directly invoke any package
names, you don't need to change your code when the package names change due
to switching the Engine.  You only refer to some Engine's root package name
once, as a C<Muldis::Rosetta::Interface::new_machine> argument, and even
that can be read from a config file rather than being hard-coded in your
application.

The usual way that Muldis::Rosetta::Interface indicates a failure is to
throw an exception; most often this is due to invalid input.  If an invoked
routine simply returns, you can assume that it has succeeded, even if the
return value is undefined.

=head2 The Muldis::Rosetta::Interface Module

The C<Muldis::Rosetta::Interface> module is the stateless root package by
way of which you access the whole Muldis Rosetta API.  That is, you use it
to load engines and instantiate virtual machines, which provide the rest of
the Muldis Rosetta API.

=over

=item C<new_machine of Muldis::Rosetta::Interface::Machine (Str
:$engine_name!, Any :$machine_config?)>

This constructor function creates and returns a C<Machine> object that is
implemented by the Muldis Rosetta Engine named by its named argument
C<$engine_name>; that object is initialized using the C<$machine_config>
argument.  The named argument C<$engine_name> is the name of a Perl module
that is expected to be the root package of a Muldis Rosetta Engine, and
which is expected to declare a C<new_machine> subroutine with a single
named argument C<$machine_config>; invoking this subroutine is expected to
return an object of some class of the same Engine which does the
C<Muldis::Rosetta::Interface::Machine> role.  This function will start by
testing if the root package is already loaded (it may be declared by some
already-loaded file of another name), and only if not, will it do a Perl
'require' of the C<$engine_name>.

=back

=head2 The Muldis::Rosetta::Interface::Machine Role

A C<Machine> object represents a single active Muldis Rosetta virtual
machine / Muldis D environment, which is the widest scope stateful context
in which any other database activities happen.  Other activities meaning
the compilation and execution of Muldis D code, mounting or unmounting
depots, performing queries, data manipulation, data definition, and
transactions.  If a C<Machine> object is ever garbage collected by Perl
while it has any active transactions, then those will all be rolled back,
and then an exception thrown.

=over

=item C<new_process of Muldis::Rosetta::Interface::Process (Any
:$process_config?)>

This method creates and returns a new C<Process> object that is associated
with the invocant C<Machine>; that C<Process> object is initialized using
the C<$process_config> argument.

=item C<assoc_processes of Array ()>

This method returns, as elements of a new (unordered) Array, all the
currently existing C<Process> objects that are associated with the invocant
C<Machine>.

=back

=head2 The Muldis::Rosetta::Interface::Process Role

A C<Process> object represents a single Muldis Rosetta in-DBMS process,
which has its own autonomous transactional context, and for the most part,
its own isolated environment.  It is associated with a specific C<Machine>
object, the one whose C<new_process> method created it.

A new C<Process> object's "expected command language" attribute is
undefined by default, meaning that each command fed to it must declare what
language it is written in; if that attribute was made defined, then
commands fed to it would not need to declare their language and will be
interpreted according to the expected language.

=over

=item C<assoc_machine of Muldis::Rosetta::Interface::Machine ()>

This method returns the C<Machine> object that the invocant C<Process> is
associated with.

=item C<command_lang of Any ()>

This method returns the fully qualified name of its invocant C<Process>
object's "expected command language" attribute, which might be undefined;
if it is defined, then is either a Perl Str that names a Plain Text
language, or it is a Perl (ordered) Array that names a Perl Hosted Data
language; these may be Muldis D dialects or some other language.

=item C<update_command_lang (Any :$lang!)>

This method assigns a new (possibly undefined) value to its invocant
C<Process> object's "expected command language" attribute.  This method
dies if the specified language is defined and its value isn't one that the
invocant's Engine knows how to or desires to handle.

=item C<new_value of Muldis::Rosetta::Interface::Value (Str :$decl_type!)>

This method creates and returns a new C<Value> object that is associated
with the invocant C<Process>, and whose declared Muldis D type is named by
the C<$decl_type> argument, and whose default Muldis D value is the default
value of its declared type.

=item C<assoc_values of Array ()>

This method returns, as elements of a new (unordered) Array, all the
currently existing C<Value> objects that are associated with the invocant
C<Process>.

=item C<func_invo of Muldis::Rosetta::Interface::Value (Str :$function!,
Hash :$args?)>

This method invokes the Muldis D function named by its C<$function>
argument, giving it arguments from C<$args>, and then returning the result
as a C<Value> object.

=item C<upd_invo (Str :$updater!, Hash :$upd_args!, Hash :$ro_args?)>

This method invokes the Muldis D updater named by its C<$updater> argument,
giving it subject-to-update arguments from C<$upd_args> and read-only
arguments from C<$ro_args>; the C<Value> objects in C<$upd_args> are
possibly substituted for other C<value> objects as a side-effect of the
updater's execution.

=item C<proc_invo (Str :$procedure!, Hash :$upd_args?, Hash :$ro_args?)>

This method invokes the Muldis D procedure (or system_service) named by its
C<$procedure> argument, giving it subject-to-update arguments from
C<$upd_args> and read-only arguments from C<$ro_args>; the C<Value> objects
in C<$upd_args> are possibly substituted for other C<value> objects as a
side-effect of the procedure's execution.

=item C<trans_nest_level of Int ()>

This method returns the current transaction nesting level of its invocant's
virtual machine process.  If no explicit transactions were started, then
the nesting level is zero, in which case the process is conceptually
auto-committing every successful Muldis D statement.  Each call of
C<start_trans> will increase the nesting level by one, and each
C<commit_trans> or C<rollback_trans> will decrease it by one (it can't be
decreased below zero).  Note that all transactions started or ended within
Muldis D code (except direct boot_call transaction management) are attached
to a particular lexical scope in the Muldis D code (specifically a
"try/catch" context), and so they will never have any effect on the nest
level that Perl sees (assuming that a Muldis D host language will never be
invoked by Muldis D), regardless of whether the Muldis D code successfully
returns or throws an exception.

=item C<start_trans ()>

This method starts a new child-most transaction within the invocant's
virtual machine process.

=item C<commit_trans ()>

This method commits the child-most transaction within the invocant's
virtual machine process; it dies if there isn't one.

=item C<rollback_trans ()>

This method rolls back the child-most transaction within the invocant's
virtual machine process; it dies if there isn't one.

=back

=head2 The Muldis::Rosetta::Interface::Value Role

A C<Value> object is a Muldis D variable that is lexically scoped to the
Perl environment (like an ordinary Perl variable).  It is associated with a
specific C<Process> object, the one whose C<new_value> method created it,
but it is considered anonymous and non-invokable within the virtual
machine. The only way for Muldis D code to work with these variables is if
they bound to Perl invocations of Muldis D routines being C<call(|\w+)> by
Perl; a Muldis D routine parameter one is bound to is the name it is
referenced by in the virtual machine.  C<Value> objects are the normal way
to directly share or move data between the Muldis D and Perl environments.
A C<Value> is strongly typed, and the declared Muldis D type of the
variable (which affects what values it is allowed to hold) is set when the
C<Value> object is created, and this declared type can't be changed
afterwards.

=over

=item C<assoc_process of Muldis::Rosetta::Interface::Process ()>

This method returns the C<Process> object that the invocant C<Value> is
associated with.

=item C<decl_type of Str ()>

This method returns the declared Muldis D type of its invocant C<Value>.

=item C<fetch_ast of Array ()>

This method returns the current Muldis D value of its invocant C<Value> as
a Perl Hosted Data Muldis D data structure (whose root node is a Perl
Array).

=item C<store_ast (Array :$ast!)>

This method assigns a new Muldis D value to its invocant C<Value>, which is
supplied in the C<$ast> argument; the argument is expected to be a valid
Perl Hosted Data Muldis D data structure (whose root node is a Perl Array).

=back

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

=head1 INCOMPATIBILITIES

None reported.

=head1 SEE ALSO

Go to L<Muldis::Rosetta> for the majority of distribution-internal
references, and L<Muldis::Rosetta::SeeAlso> for the majority of
distribution-external references.

=head1 BUGS AND LIMITATIONS

The Muldis Rosetta framework for Perl 5 is built according to certain
old-school or traditional Perl-5-land design principles, including that
there are no explicit attempts in code to enforce privacy of the
framework's internals, besides not documenting them as part of the public
API.  (The Muldis Rosetta framework for Perl 6 is different.)  That said,
you should still respect that privacy and just use the public API that
Muldis Rosetta provides.  If you bypass the public API anyway, as Perl 5
allows, you do so at your own peril.

I<This documentation is pending.>

=head1 AUTHOR

Darren Duncan (C<perl@DarrenDuncan.net>)

=head1 LICENSE AND COPYRIGHT

This file is part of the Muldis Rosetta framework.

Muldis Rosetta is Copyright © 2002-2008, Darren Duncan.

See the LICENSE AND COPYRIGHT of L<Muldis::Rosetta> for details.

=head1 TRADEMARK POLICY

The TRADEMARK POLICY in L<Muldis::Rosetta> applies to this file too.

=head1 ACKNOWLEDGEMENTS

The ACKNOWLEDGEMENTS in L<Muldis::Rosetta> apply to this file too.

=cut
