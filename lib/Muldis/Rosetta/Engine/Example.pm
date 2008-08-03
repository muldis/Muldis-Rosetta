use 5.008001;
use utf8;
use strict;
use warnings FATAL => 'all';

use Muldis::Rosetta::Interface;

###########################################################################
###########################################################################

{ package Muldis::Rosetta::Engine::Example; # module
    use version; our $VERSION = qv('0.7.0');
    # Note: This given version applies to all of this file's packages.

###########################################################################

sub new_machine {
    my ($args) = @_;
    my ($machine_config) = @{$args}{'machine_config'};
    return Muldis::Rosetta::Engine::Example::Public::Machine->new({
        'machine_config' => $machine_config });
}

###########################################################################

} # module Muldis::Rosetta::Engine::Example

###########################################################################
###########################################################################

{ package Muldis::Rosetta::Engine::Example::Public::Machine; # class
    use base 'Muldis::Rosetta::Interface::Machine';

    use Carp;

    # User-supplied config data for this Machine object.
    # For the moment, the Example Engine doesn't actually have anything
    # that can be config in this way, so input $machine_config is ignored.
    my $ATTR_MACHINE_CONFIG = 'machine_config';

    # Lists of user-held objects associated with parts of this Machine.
    # For each of these, Hash keys are obj .WHERE/addrs, vals the objs.
    # These should be weak obj-refs, so objs disappear from here
    my $ATTR_ASSOC_PROCESSES = 'assoc_processes';

###########################################################################

sub new {
    my ($class, $args) = @_;
    my $self = bless {}, $class;
    $self->_build( $args );
    return $self;
}

sub _build {
    my ($self, $args) = @_;
    my ($machine_config) = @{$args}{'machine_config'};

    # TODO: input checks.
    $self->{$ATTR_MACHINE_CONFIG} = $machine_config;

    $self->{$ATTR_ASSOC_PROCESSES} = {};

    return;
}

sub DESTROY {
    my ($self) = @_;
    # TODO: check for active trans and rollback ... or member VM does it.
    # Likewise with closing open files or whatever.
    return;
}

###########################################################################

sub new_process {
    my ($self, $args) = @_;
    my ($process_config) = @{$args}{'process_config'};
    return Muldis::Rosetta::Engine::Example::Public::Process->new({
        'machine' => $self, 'process_config' => $process_config });
}

sub assoc_processes {
    my ($self) = @_;
    return [values %{$self->{$ATTR_ASSOC_PROCESSES}}];
}

###########################################################################

} # class Muldis::Rosetta::Engine::Example::Public::Machine

###########################################################################
###########################################################################

{ package Muldis::Rosetta::Engine::Example::Public::Process; # class
    use base 'Muldis::Rosetta::Interface::Process';

    use Carp;
    use Scalar::Util qw( refaddr weaken );

    my $ATTR_MACHINE = 'machine';

    # User-supplied config data for this Process object.
    # For the moment, the Example Engine doesn't actually have anything
    # that can be config in this way, so input $process_config is ignored.
    my $ATTR_PROCESS_CONFIG = 'process_config';

    my $ATTR_COMMAND_LANG = 'command_lang';

    # Lists of user-held objects associated with parts of this Process.
    # For each of these, Hash keys are obj .WHERE/addrs, vals the objs.
    # These should be weak obj-refs, so objs disappear from here
    my $ATTR_ASSOC_VALUES = 'assoc_values';

    # Maintain actual state of the this DBMS' virtual machine.
    # TODO: the VM itself should be in another file, this attr with it.
    my $ATTR_TRANS_NEST_LEVEL = 'trans_nest_level';

    # Allow Process objs to update Machine's "assoc" list re themselves.
    my $MACHINE_ATTR_ASSOC_PROCESSES = 'assoc_processes';

###########################################################################

sub new {
    my ($class, $args) = @_;
    my $self = bless {}, $class;
    $self->_build( $args );
    return $self;
}

sub _build {
    my ($self, $args) = @_;
    my ($machine, $process_config) = @{$args}{'machine', 'process_config'};

    $self->{$ATTR_MACHINE} = $machine;
    $machine->{$MACHINE_ATTR_ASSOC_PROCESSES}->{refaddr $self} = $self;
    weaken $machine->{$MACHINE_ATTR_ASSOC_PROCESSES}->{refaddr $self};

    # TODO: input checks.
    $self->{$ATTR_PROCESS_CONFIG} = $process_config;

    $self->{$ATTR_COMMAND_LANG} = undef;

    $self->{$ATTR_ASSOC_VALUES} = {};

    $self->{$ATTR_TRANS_NEST_LEVEL} = 0;

    return;
}

sub DESTROY {
    my ($self) = @_;
    # TODO: check for active trans and rollback ... or member VM does it.
    # Likewise with closing open files or whatever.
    delete $self->{$ATTR_MACHINE}->{
        $MACHINE_ATTR_ASSOC_PROCESSES}->{refaddr $self};
    return;
}

###########################################################################

sub assoc_machine {
    my ($self) = @_;
    return $self->{$ATTR_MACHINE};
}

###########################################################################

sub command_lang {
    my ($self) = @_;
    return $self->{$ATTR_COMMAND_LANG};
}

sub update_command_lang {
    my ($self, $args) = @_;
    my ($lang) = @{$args}{'lang'};
    $self->{$ATTR_COMMAND_LANG} = $lang;
    return;
}

###########################################################################

sub execute {
    my ($self, $args) = @_;
    my ($source_code) = @{$args}{'source_code'};

    # TODO: execute $source code

    return;
}

###########################################################################

sub new_value {
    my ($self, $args) = @_;
    my ($source_code) = @{$args}{'source_code'};
    return Muldis::Rosetta::Engine::Example::Public::Value->new({
        'process' => $self, 'source_code' => $source_code });
}

sub assoc_values {
    my ($self) = @_;
    return [values %{$self->{$ATTR_ASSOC_VALUES}}];
}

###########################################################################

sub func_invo {
    my ($self, $args) = @_;
    my ($function, $f_args) = @{$args}{'function', 'args'};

    my $result;

    return $result;
}

sub upd_invo {
    my ($self, $args) = @_;
    my ($updater, $upd_args, $ro_args)
        = @{$args}{'updater', 'upd_args', 'ro_args'};

    return;
}

sub proc_invo {
    my ($self, $args) = @_;
    my ($procedure, $upd_args, $ro_args)
        = @{$args}{'procedure', 'upd_args', 'ro_args'};

    return;
}

###########################################################################

sub trans_nest_level {
    my ($self) = @_;
    return $self->{$ATTR_TRANS_NEST_LEVEL};
}

sub start_trans {
    my ($self) = @_;
    # TODO: the actual work.
    $self->{$ATTR_TRANS_NEST_LEVEL} ++;
    return;
}

sub commit_trans {
    my ($self) = @_;
    confess q{commit_trans(): Could not commit a transaction;}
            . q{ none are currently active.}
        if $self->{$ATTR_TRANS_NEST_LEVEL} == 0;
    # TODO: the actual work.
    $self->{$ATTR_TRANS_NEST_LEVEL} --;
    return;
}

sub rollback_trans {
    my ($self) = @_;
    confess q{rollback_trans(): Could not rollback a transaction;}
            . q{ none are currently active.}
        if $self->{$ATTR_TRANS_NEST_LEVEL} == 0;
    # TODO: the actual work.
    $self->{$ATTR_TRANS_NEST_LEVEL} --;
    return;
}

###########################################################################

} # class Muldis::Rosetta::Engine::Example::Public::Process

###########################################################################
###########################################################################

{ package Muldis::Rosetta::Engine::Example::Public::Value; # class
    use base 'Muldis::Rosetta::Interface::Value';

    use Carp;
    use Scalar::Util qw( refaddr weaken );

    my $ATTR_PROCESS = 'process';

    my $ATTR_VALUE = 'value';
    # TODO: cache Perl-Hosted Muldis D version of $!value.

    # Allow Value objs to update Process' "assoc" list re themselves.
    my $PROCESS_ATTR_ASSOC_VALUES = 'assoc_values';

###########################################################################

sub new {
    my ($class, $args) = @_;
    my $self = bless {}, $class;
    $self->_build( $args );
    return $self;
}

sub _build {
    my ($self, $args) = @_;
    my ($process, $source_code) = @{$args}{'process', 'source_code'};

    $self->{$ATTR_PROCESS} = $process;
    $process->{$PROCESS_ATTR_ASSOC_VALUES}->{refaddr $self} = $self;
    weaken $process->{$PROCESS_ATTR_ASSOC_VALUES}->{refaddr $self};

    # TODO: input checks.
#    $self->{$ATTR_VALUE} = Muldis::Rosetta::Engine::Example::VM::Value->new({
#        'source_code' => $source_code }); # TODO; or some such

    return;
}

sub DESTROY {
    my ($self) = @_;
    delete $self->{$ATTR_PROCESS}->{
        $PROCESS_ATTR_ASSOC_VALUES}->{refaddr $self};
    return;
}

###########################################################################

sub assoc_process {
    my ($self) = @_;
    return $self->{$ATTR_PROCESS};
}

###########################################################################

sub source_code {
    my ($self, $args) = @_;
    my ($lang) = @{$args}{'lang'};
#    return $self->{$ATTR_VALUE}->source_code( $lang ); # TODO; or som such
    return;
}

###########################################################################

} # class Muldis::Rosetta::Engine::Example::Public::Value

###########################################################################
###########################################################################

1; # Magic true value required at end of a reusable file's code.
__END__

=pod

=encoding utf8

=head1 NAME

Muldis::Rosetta::Engine::Example -
Self-contained reference implementation of a Muldis Rosetta Engine

=head1 VERSION

This document describes Muldis::Rosetta::Engine::Example version 0.7.0 for
Perl 5.

It also describes the same-number versions for Perl 5 of
Muldis::Rosetta::Engine::Example::Public::Machine,
Muldis::Rosetta::Engine::Example::Public::Process,
Muldis::Rosetta::Engine::Example::Public::Value.

=head1 SYNOPSIS

I<This documentation is pending.>

=head1 DESCRIPTION

B<Muldis::Rosetta::Engine::Example>, aka the I<Muldis Rosetta Example
Engine>, aka I<Example>, is the self-contained and pure-Perl reference
implementation of Muldis Rosetta.  It is included in the Muldis Rosetta
core distribution to allow the core to be completely testable on its own.

Example is coded intentionally in a simple fashion so that it is easy to
maintain and and easy for developers to study.  As a result, while it
performs correctly and reliably, it also performs quite slowly; you should
only use Example for testing, development, and study; you should not use it
in production.  (See the L<Muldis::Rosetta::SeeAlso> file for a list of
other Engines that are more suitable for production.)

This C<Muldis::Rosetta::Engine::Example> file is the main file of the
Example Engine, and it is what applications quasi-directly invoke; its
C<Muldis::Rosetta::Engine::Example::Public::\w+> classes directly
do/subclass the roles/classes in L<Muldis::Rosetta::Interface>.  The other
C<Muldis::Rosetta::Engine::Example::\w+> files are used internally by this
file, comprising the rest of the Example Engine, and are not intended to be
used directly in user code.

I<This documentation is pending.>

=head1 INTERFACE

Muldis::Rosetta::Engine::Example supports multiple command languages, all
of which are official Muldis D dialects.  You may supply commands to
Example written in any of the following:

=over

=item B<Tiny Plain Text Muldis D>

See L<Muldis::D::Dialect::PTMD_Tiny> for details.

The language name is specified either as a Perl character string whose
value is C<Muldis_D:'http://muldis.com':'0.43.0':'PTMD_Tiny':{}> or as a
Perl array whose value is C<[ 'Muldis_D', 'http://muldis.com', '0.43.0',
'PTMD_Tiny', {} ]>.  No other version numbers are currently supported.

=item B<Tiny Perl Hosted Data Muldis D>

See L<Muldis::D::Dialect::HDMD_Perl_Tiny> for details.

The language name is specified either as a Perl character string whose
value is C<Muldis_D:'http://muldis.com':'0.43.0':'HDMD_Perl_Tiny':{}> or as
a Perl array whose value is C<[ 'Muldis_D', 'http://muldis.com', '0.43.0',
'HDMD_Perl_Tiny', {} ]>.  No other version numbers are currently supported.

=back

You may also supply or retrieve data through Example in any of the above.

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
L<Muldis::Rosetta::Interface-0.7.0|Muldis::Rosetta::Interface>.

=head1 INCOMPATIBILITIES

None reported.

=head1 SEE ALSO

Go to L<Muldis::Rosetta> for the majority of distribution-internal
references, and L<Muldis::Rosetta::SeeAlso> for the majority of
distribution-external references.

=head1 BUGS AND LIMITATIONS

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
