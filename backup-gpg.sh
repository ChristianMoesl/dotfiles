#!/bin/zsh

set -e

mkdir results
cd results

export KEYID="769769A118926F65694385A400E80FCE30C2947A"

gpg --armor --export-secret-key $KEYID > master.key
gpg --armor --export-secret-subkeys $KEYID > sub.key

gpg --send-key $KEYID
gpg --keyserver pgp.mit.edu --send-key $KEYID
gpg --keyserver keys.gnupg.net --send-key $KEYID
gpg --keyserver hkps://keyserver.ubuntu.com:443 --send-key $KEYID

split -b 2953 master.key master-
split -b 2953 sub.key sub-

for file in ./*-*
do
  qrencode --8bit -o "$file.png" < "$file"
done

convert `ls -v *.png` -page a4x5x5 -gravity Center ../gpg-backup.pdf

#rm -rf results
