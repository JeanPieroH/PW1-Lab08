#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $q=CGI->new();
my $expresion=$q->param("expresion");
my $resultado=evaluarExpresion($expresion);

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

sub evaluarExpresion{
  my $expresion=$_[0];

  while (not $expresion=~/^[0-9]+(\.[0-9]+)?$/ and not $expresion=~/No se puede dividir por 0/){
    $expresion=evaluarOperacion($expresion);
  }

  return $expresion;
}

sub evaluarOperacion{
  my $expresion=$_[0];
  my $resultado;
  
  if ($expresion=~/([0-9]+(\.[0-9]+)?)([\*\/])([0-9]+(\.[0-9]+)?)/){
    $resultado=operacion($1,$3,$4);
    $expresion=~s/([0-9]+(\.[0-9]+)?)([\*\/])([0-9]+(\.[0-9]+)?)/$resultado/;    
  } 
  elsif ($expresion=~/([0-9]+(\.[0-9]+)?)([\+\-])([0-9]+(\.[0-9]+)?)/){
    $resultado=operacion($1,$3,$4);
    $expresion=~s/([0-9]+(\.[0-9]+)?)([\+\-])([0-9]+(\.[0-9]+)?)/$resultado/;    
  }

  return $expresion;
}


sub operacion{
  my $numero1=$_[0];
  my $operador=$_[1];
  my $numero2=$_[2];
  my $resultado;

  if ($operador eq "+"){
    $resultado=$numero1+$numero2;
  }elsif($operador eq "-"){
    $resultado=$numero1-$numero2;
  }elsif($operador eq "*"){
    $resultado=$numero1*$numero2;
  }elsif ($operador eq "/"){
    if ($numero2==0){
      $resultado="No se puede dividir por 0";
    }
    else{
      $resultado=$numero1/$numero2;
    }
  }
  return $resultado;
}
