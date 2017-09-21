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
Incremental backup considers the base backup and just stores the cahnges relative to the base backup. A baseup is normally a full backup. A level-1 backup is a backup based on a level-0 backup. A level-2 backup is a backup based on a level-1 backup, and so on. Level-1+ incremental backups could save more space but it creates a painful restoration - it requires each level incremental tar to be restored in order.

Let's say we created a weekly backup "backup-weekly.tar.gz" on SUnday morning 1:00AM. To create incremental backups:
* Simple case: repeated level-1 incrementals.
  * Monday - Saturday: level-1s 
* Complex case: level-1 to level-7 incrementals:
  * Monday - Saturday: level-1/7

In simple case, file-1.txt created on Monday would be copied in each of the subsequent level-1 incrementals. In the complex case, file-1.txt would only be stored in Monday's incrementals. To retore a file for Friday (level-5), in complex case, you will need to do the sequential restoration of level-0, level-1, level-2, level-3, level-4 and level-5. In simple case, you only need level-0 and Friday's level-1.

## Simple Incremental Backups Example:
Let's do some hands on practises.