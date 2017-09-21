## Using tar Command for Full and Incremental Backups
Lots of people know what "tar" command is, most of the times, you use "tar" for archiving files and retrieving files back. But not everyone knows that, "tar" actually stands for "tape archive", which is used by system administrators to take backups, both incremental and full backups.

The "tar" command creates a tar/gzip/bzip file from a collection of files and directories.

## "tar" Basics
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