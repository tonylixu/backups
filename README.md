## The Importance of Backup
I think we all understand the importance of backups. How many times, you've heard the story of losing some important data? And these stories might come from you, your friends, your colleagues, or even your boss, ..etc, could from everyone. Backing up your data regularly will definitely help you to avoid the crushing, heart-breaking moment.

No matter how great your compuer/server is, one day it will crash, this is just the nature of evyerhting. When emergency happens and you don't have any backups, you might be able to get your data on your computer recovered if you are lucky enough, and what if you don't? An OS or app can be reinstalled, but it may be very difficult or impossible to recreate the original data.

## You Should Backup Your Data
It is very essential that you always back up your data and have a plan for restoring. You should back up your personal or critical work data on a regular basis (Don't get lazy!)

## How to Backup Your Data
From my own professional experiences, here are some general guidelines for making a good backup:

* Storage now is very cheap, get yourself a 3TB drive and just backup everything. It just doen't cost you much!
* Cloud storgae such as AWS s3 and other cloud services. They offer great user interfaces and the cost is usually cheap. "$0.023 per GB" is the cost of AWS S3 standard storage.
* Don't put all the eggs in one basket. If you back up locally, you should back up to cloud infrequently (every quarter?) and vice versa.
* Organize your files/data before you backup, easy for recovering, don't throw everyting in one folder, have a nice file structure and you will appreciate this when you restore your data.
* Timestamp your backup nicely, for example, "tony-photo-2017.zip", you can tell what's in this zip file before you even uncompress it.
* Compress your files/data to be more efficient and save some space.
* If the data is important and sensitive, encrypt it before you upload.
* Sanitize or destroy your backups before discarding them.

## What's in This Repo?
Backup instructions, sample scripts,...