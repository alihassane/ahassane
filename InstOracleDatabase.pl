#!/usr/bin/env perl
# tested against:
#---------------------------------------------------------------|
#   Oracle Linux Server release 6.9                             |
#   NAME="Oracle Linux Server"                                  |      
#   VERSION="6.9"                                               |
#   perl, v5.10.1 (*) built for x86_64-linux-thread-multi       |
#---------------------------------------------------------------|

use strict;
use warnings;
use File::Copy;
use POSIX qw(strftime);
$| = 1;

our $dateNow = strftime("%d.%m.%Y",localtime);
our $timeNow = strftime("%H%M%S",localtime);

print "$dateNow $timeNow\n";   
our $run_cmd='';
#- Global Variables Section -
our @pkgs =(
'cloog-ppl',
'libXxf86misc',
'compat-libcap1',
'libXxf86vm',
'compat-libstdc++-33',
'libaio-devel',
'cpp',
'libdmx',
'gcc',
'libstdc++-devel',
'gcc-c++',
'mpfr',
'glibc-devel',
'make',
'glibc-headers',
'ppl',
'kernel-headers',
'xorg-x11-utils',
'libXmu',
'xorg-x11-xauth',
'libXt',
'libXv',
'ksh',
'libXxf86dga',
'binutils',
'libgcc',
'libXi',
'sysstat');

    print "Total number of required packages = $#pkgs\n";
# End of Global Variable Section -


sub main(){

my $cmd_chk = "rpm -qa | grep -w ";
my $cmd_inst = "yum install -y ";
my $idx = 0;
while ($idx <= $#pkgs){
my $pkg = $pkgs[$idx];
my $run_cmd = `$cmd_chk $pkg 2>&1`;
my $returnCode = $?;
if ($returnCode == 0){
    print "$pkg -- found installed on the system\n";
splice(@pkgs,$idx,1);
}else{ 
    $idx++;}
    }

if ($#pkgs <= 0){
    print "All Required packages found installed on the system.\n";
}else{
print "Total number of packages to be downloaded and installed = $#pkgs\n";
$run_cmd = `$cmd_inst @pkgs`;
}

kernel_pram();
}

sub kernel_pram(){
    my $file_name = '/etc/sysctl.conf';
    copy $file_name,"$file_name.$dateNow.$timeNow.backup";
    my $cmd_mem = 'free -b | sed -n \'2p\' | awk \'{print $2}\'';
    my $memTotal = `$cmd_mem 2>&1`;
    my $pageSize = `getconf PAGE_SIZE 2>&1`;

    my $shmMax = ($memTotal / 2);
    my $shmmni = 4096;

    my $kernelShmal =(($shmMax/$pageSize)*($shmmni/16));
my $idx=0;
my $x = "hello.world";
my $y = substr($x, 0, index($x, '.'));

my @sourceFile=();
my @newFile = (
"fs.aio-max-nr = 1048576\n",
"fs.file-max = 6815744\n",
"kernel.shmmax = $shmMax\n",
"kernel.shmall = $kernelShmal\n",
"kernel.shmmni = $shmmni\n",
"kernel.sem = 250 32000 100 128\n",
"net.ipv4.ip_local_port_range = 9000 65500\n",
"net.core.rmem_default = 262144\n",
"net.core.rmem_max = 4194304\n",
"net.core.wmem_default = 262144\n",
"net.core.wmem_max = 1048576\n"
);
open (FHs,$file_name) || die("problem: $!");


while (<FHs>){
    next if /^#/ || /^$/;
    push @sourceFile, $_;
   
}
#print @sourceFile;


 
my $z; my $v;
for (my $i =0; $i<= $#sourceFile; $i++){
    $z = substr($sourceFile[$i],0, index($sourceFile[$i],'='));
    #print $z;
    for (my $j =0; $j <= $#newFile; $j++){
    $v = substr($newFile[$j],0, index($newFile[$j],'='));
     if ($z eq $v ){
         print "$z . source - $v . new \n";
         print "$sourceFile[$i] - $newFile[$j]\n";
     }
    }
}
}


#Execution
main(); 
#End 

