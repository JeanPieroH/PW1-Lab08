#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $q=CGI->new();
my $expresion=$q->param("expresion");
my $resultado;

if($expresion=~/([0-9]+)([\+\-\*\/])([0-9]+)/){
  my $numero1=$1;
  my $operador=$2;
  my $numero2=$3;
  $resultado=operacion($numero1,$operador,$numero2);
}
else{
  $resultado="No ingreso una expresion valida";
}

print $q->header("text/html");
print <<BLOCK;
<!DOCTYPE html>
<html lang="es">
  <head> 
    <title></title>
    <meta charset="UTF-8">
  </head>

  <body>
    <h1>Calculadora</h1>
    <form action="../index.html">
      <p>Resultado: $resultado</p>
      <p><input type="submit" value="Regresar"></p>
    </form>
  </body>
</html>
BLOCK

sub operacion{
  my $numero1=$_[0];
  my $operador=$_[1];
  my $numero2=$_[2];
  my $resultado;

  if ($operador eq "+"){
    $resultado=$numero1+$numero2;
  } elsif($operador eq "-"){
    $resultado=$numero1-$numero2;
  } elsif($operador eq "*"){
    $resultado=$numero1*$numero2;
  }elsif ($operador eq "/"){
    $resultado=$numero1/$numero2;
  }
  return $resultado;
}
