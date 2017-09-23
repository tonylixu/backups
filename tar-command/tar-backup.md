## Using tar Command for Full and Incremental Backups
Lots of people know what "tar" command is, most of the times, you use "tar" for archiving files and retrieving files back. But not everyone knows that, "tar" actually stands for "tape archive", which is used by system administrators to take backups, both incremental and full backups.

The "tar" command creates a tar/gzip/bzip file from a collection of files and directories.

## "tar" Basics - Full backup
To create an archive from tar command is easy:
```bash
$ tar -cvf backup.tar /source/path
or
$ tar -czvf backup.tar.gz /source/path
or
$ tar -cjvf backup.tar.bz2 /source/path
```
The above command creates "backup.tar" from "/source/path".
```bash
    - c: creating archive
    - v: verbose mode
    - f: filename type
    - z/j: compressed archive
```

To Uncompress an archive:
```bash
$ tar -xvf backup.tar
or
$ tar -xvf backup.tar.gz -c /target/directory
```
The above commands will extract "backup.tar" to the current working directory or the "target/girectory"

The example we just show is a "fullbackup". "tar" allows us to do two kinds of backups:
* level-0 backup: full backup
* level1-# backup: incremental backup

## Incremental Backup
Incremental backup considers the base backup and just stores the changes relative to the base backup. A base backup is normally a full backup. A level-1 backup is a backup based on a level-0 backup. A level-2 backup is a backup based on a level-1 backup, and so on. Level-1+ incremental backups could save more space but it creates a painful restoration - it requires each level incremental tar to be restored in order.

Let's say we created a weekly backup "backup-weekly.tar.gz" on Sunday morning 1:00AM. To create incremental backups:
* Simple case: repeated level-1 incrementals.
  * Monday - Saturday: level-1s 
* Complex case: level-1 to level-7 incrementals:
  * Monday - Saturday: level-1/7

In simple case, file-1.txt created on Monday would be copied in each of the subsequent level-1 incrementals. In the complex case, file-1.txt would only be stored in Monday's incrementals. To retore a file for Friday (level-5), in complex case, you will need to do the sequential restoration of level-0, level-1, level-2, level-3, level-4 and level-5. In simple case, you only need level-0 and Friday's level-1.

## Simple Incremental Backups Example:
Let's do some hands on practises.

* Run make_files bash script:
```bash
$ ./make_files
Creating test parent folder
Creating subfolders and files

$ tree test/
test/
|-- a
|-- bar
|   `-- c
`-- foo
    |-- b
    |-- baz
    |-- c
    `-- d

3 directories, 5 files
```
* Make the level-0 (full backup):
```bash
$ tar --listed-incremental test_backup.snar -czpf test_backup_full.tar.gz test
$ ls
change_files  make_files  tar-backup.md  test  test_backup_full.tar.gz  test_backup.snar
```
Now we have our level-0 full backup. Notice that this time we used the option "--listed-incremental", and we have a "test_backup.snar" file. This file will be used later to tell our subsequent backups what is in the level-0 backup.

* Let's make some changes to the test folder
```bash
$ ./change_files
$ tree test
test
|-- a
|-- bar
|   |-- c
|   `-- new
|       `-- f
|-- e
`-- foo
    |-- b
    |-- c
    `-- d

3 directories, 7 files
```
You can see the test folder did get changed.

* Let's make a level-1 incremental backup:
```bash
# Let's be careful on the *.snar file, make a copy before playing with it
$ cp test_backup.snar test_backup.snar.full
$ tar --listed-incremental test_backup.snar -czpf test_backup_incremental_1.tar.gz test
$ ls
change_files  tar-backup.md  test_backup_full.tar.gz           test_backup.snar      test_backup.snar.full
make_files    test           test_backup_incremental_1.tar.gz
$ diff test_backup.snar test_backup.snar.full
Binary files test_backup.snar and test_backup.snar.full differ
```
Now we have a level-0 and level-1 backup. I can keep making more level-1 backups by using "test_backup.snar.full" file as their --listed-incremental file. You have to make a copy, because "tar' keeps changing the snar file to reflect its work.

## Restore
### Note: Restore doesn't require the *.snar file
Restoring the incremental backup requires you to restore the full backup first. Let's give a try:
* Remove the test folder:
```bash
$ mv test test-bak
```
* Restore the full backup
```bash
$ tar -xzvpf test_backup_full.tar.gz
test/
test/bar/
test/foo/
test/foo/baz/
test/a
test/bar/c
test/foo/b
test/foo/c
test/foo/d
$ tree test
test
|-- a
|-- bar
|   `-- c
`-- foo
    |-- b
    |-- baz
    |-- c
    `-- d

3 directories, 5 files
```
You can see we are back to the step before we run "change_files" script.
* Now restore the incremental backup
```bash
$ tar --incremental -xzvpf test_backup_incremental_1.tar.gz
test/
test/bar/
test/bar/new/
test/foo/
test/e
test/bar/new/f
test/foo/b
$ tree test
test
|-- a
|-- bar
|   |-- c
|   `-- new
|       `-- f
|-- e
`-- foo
    |-- b
    |-- c
    `-- d

3 directories, 7 files
$ diff --brief -r test test-bak/
```
Now we back to the state that when we just run "change_files" script.

## Incremental Dry Run
If you want, you can use the "--incremental" option to check what were changed in incremental backups:
```bash
$ tar  --incremental -tvvzpf test_backup_incremental_1.tar.gz
drwxr-xr-x root/root        45 2017-09-21 13:59 test/
N a
D bar
Y e
D foo
R test/foo/baz
T test/bar/new

drwxr-xr-x root/root         9 2017-09-21 13:59 test/bar/
N c
D new

drwxr-xr-x root/root         4 2017-09-21 13:59 test/bar/new/
Y f

drwxr-xr-x root/root        10 2017-09-21 13:59 test/foo/
Y b
N c
N d

-rw-r--r-- root/root        13 2017-09-21 13:59 test/e
-rw-r--r-- root/root        19 2017-09-21 13:59 test/bar/new/f
-rw-r--r-- root/root        22 2017-09-21 13:59 test/foo/b

'Y' - filename is contained in the archive.

'N' -filename was present in the directory at the time the archive was made, yet it was not dumped to the archive, because it had not changed since the last backup.

'D' - filename is a directory.

'R' - This code requests renaming of the filename to the name specified with the `T' command, that immediately follows it.

'T' - Specify target file name for `R' command

'X' - Specify temporary directory name for a rename operation (see below).
```
