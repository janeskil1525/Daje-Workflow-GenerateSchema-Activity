package Daje::Workflow::GenerateSchema::Activity;
use Mojo::Base 'Daje::Workflow::Common::Activity::Base', -base, -signatures;

use Mojo::JSON qw{to_json};
use Daje::Workflow::GenerateSchema::Create::Schema;
use Mojo::Pg;


# NAME
# ====
#
# Daje::Workflow::GenerateSchema::Activity - It pulls the schema out of a postgres database
#
# SYNOPSIS
# ========
#
#     use Daje::Workflow::GenerateSchema::Activity;
#
# DESCRIPTION
# ===========
#
# Daje::Workflow::GenerateSchema::Activity is ...
#
# LICENSE
# =======
#
# Copyright (C) janeskil1525.
#
# This library is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# AUTHOR
# ======
#
# janeskil1525 E<lt>janeskil1525@gmail.comE<gt>
#
#
#

our $VERSION = "0.01";



sub process ($self) {

    my $schema = $self->_load_db_schema();
    my $json = $self->_build_json($schema);
    $self->_save_json($json);

    return 1;
}

sub _create_database($self) {
    Daje::Workflow::Database->new(
        pg          => pg,
        migrations  => $migrations,
    )->migrate_from_file();
}

sub _load_db_schema($self) {

    my $dbschema = Daje::Workflow::GenerateSchema::Create::Schema->new(
        db => $self->db
    )->get_db_schema('public');

    return $dbschema;
}

sub _build_json($self, $schema) {
    my $json = to_json($schema);

    return $json;
}

sub _save_json($self, $json) {

    my $path = $self->config->{DATABASE}->{output_dir};
    open(my $fh, ">", $path . 'schema.json')
        or die "could not open $path . 'schema.json";
    print $fh $json;
    close $fh;

}

1;
__END__



