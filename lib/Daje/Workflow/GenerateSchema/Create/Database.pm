package Daje::Workflow::GenerateSchema::Create::Database;
use Mojo::Base  -base, -signatures;

has 'context';
has 'pg';
has 'dbname' => 'postgres';

sub create($self){

    my $pg = $self->_connect($self->dbname());

    $self->_dbname();
    $pg->db->query("CREATE DATABASE " . $self->dbname());
    $pg = $self->_connect($self->dbname());

    my $sql = $self->context->{context}->{sql};
    my $length = scalar @{$sql};
    for (my $i = 0; $i < $length; $i++) {
        $pg->migrations->from_string(@{$sql}[$i]->{data})->migrate->latest();
    }

    $self->pg($pg);
}

sub _connect($self, $dbname) {

    my $dbconn = $self->context->{context}->{dbconn};
    $dbconn =~ s/DB/$dbname/;

    my $pg = Mojo::Pg->new->dsn(
        $dbconn
    );

    return $pg;
}

sub _dbname($self) {

    my @chars = ('A'..'x');
    my $len = 8;
    my $string;
    while($len--){ $string .= $chars[rand @chars] };

    $self->dbname($string);

}
1;
#################### pod generated by Pod::Autopod - keep this line to make pod updates possible ####################

=head1 NAME

Daje::Workflow::GenerateSchema::Create::Database


=head1 REQUIRES

L<Mojo::Base> 


=head1 METHODS

=head2 create($self)

 create($self)();


=cut

