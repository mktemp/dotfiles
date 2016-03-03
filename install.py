#!/usr/bin/python3

import subprocess, os, sys
from sys import stderr
from paths import paths

CONFIGS_DIR = "./config/"

success = []
failed = []
ignored = []

if __name__ == "__main__":
    for file, dest in paths.items():
        dest = os.path.expanduser( dest )
        if os.path.isdir( dest ):
            if not dest.endswith('/'): dest += '/'
            dest += file

        if os.path.exists( CONFIGS_DIR + file ):
            backupresult = subprocess.run( ( 'sh', '-c', 'cp -L ' + dest + ' ' + dest + '.backup'), stderr = subprocess.PIPE )
            lnresult = subprocess.run( ('sh', '-c', 'ln -sf ' + os.path.realpath( CONFIGS_DIR + file ) + ' ' + dest), stderr = subprocess.PIPE )
        else: 
            failed.append( (os.path.realpath( CONFIGS_DIR + file ), dest) )
            continue

        if lnresult.returncode != 0:
            failed.append( ( os.path.realpath( CONFIGS_DIR + file ), dest ) )
        else:
            success.append( ( os.path.realpath( CONFIGS_DIR + file ), dest ) )

    for file in subprocess.Popen( ('ls', '-a1', CONFIGS_DIR), stdout = subprocess.PIPE ).stdout.read().decode().split( '\n' ):
        if file in ('.', '..', ''):
            continue
        realpath = os.path.realpath( CONFIGS_DIR + file )
        if realpath not in (i for i, _ in success) and realpath not in (i for i, _ in failed):
            ignored.append( file )   

    print( 'Successfully linked:' )
    print( '\n'.join( '    %s -> %s' % ( src, dst ) for src, dst in success ) )
    print( 'Failed:' )
    print( '\n'.join( '    %s !-> %s' % ( src, dst ) for src, dst in failed ) )
    print( 'Ignored by config:' )
    print( '\n'.join( '    %s' % ( src ) for src in ignored ) )
