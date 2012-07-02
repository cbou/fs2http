

<!-- Start /home/charles/Repositories/fs2http/docs/../lib/routes/exists.coffee -->



## Exists route
Test whether or not the given path exists

> Method: GET

> Default URL: /fs2http/exists



### Params: 

* **String** *path* The path







<!-- End /home/charles/Repositories/fs2http/docs/../lib/routes/exists.coffee -->



<!-- Start /home/charles/Repositories/fs2http/docs/../lib/routes/ls.coffee -->



## Ls route
Read a directory

> Method: GET

> Default URL: /fs2http/ls



### Params: 

* **String** *path* The path







<!-- End /home/charles/Repositories/fs2http/docs/../lib/routes/ls.coffee -->



<!-- Start /home/charles/Repositories/fs2http/docs/../lib/routes/chownRec.coffee -->



## ChownRec route
change file owner and group recursively

> Method: POST

> Default URL: /fs2http/chownRec



### Params: 

* **String** *path* The path

* **String** *uid* The new uid

* **String** *gid* The new gid







<!-- End /home/charles/Repositories/fs2http/docs/../lib/routes/chownRec.coffee -->



<!-- Start /home/charles/Repositories/fs2http/docs/../lib/routes/readlink.coffee -->



## Readlink route
Print value of a symbolic link or canonical file name

> Method: GET

> Default URL: /fs2http/readlink



### Params: 

* **String** *path* The path







<!-- End /home/charles/Repositories/fs2http/docs/../lib/routes/readlink.coffee -->



<!-- Start /home/charles/Repositories/fs2http/docs/../lib/routes/writeFile.coffee -->



## WriteFile route
Write the content of a file

> Method: POST

> Default URL: /fs2http/writeFile



### Params: 

* **String** *path* The path 

* **String** *data* The content to write

* **String** *encoding* The encoding of the data (optional, default is setted from Node.js)







<!-- End /home/charles/Repositories/fs2http/docs/../lib/routes/writeFile.coffee -->



<!-- Start /home/charles/Repositories/fs2http/docs/../lib/routes/readdir.coffee -->



## Readdir route
Read a directory

> Method: GET

> Default URL: /fs2http/readdir



### Params: 

* **String** *path* The path







<!-- End /home/charles/Repositories/fs2http/docs/../lib/routes/readdir.coffee -->



<!-- Start /home/charles/Repositories/fs2http/docs/../lib/routes/copyRec.coffee -->



## CopyRec route
Make a copy of a file or a directory recursively

> Method: POST

> Default URL: /fs2http/copyRec



### Params: 

* **String** *path* The path

* **String** *newpath* The new path







<!-- End /home/charles/Repositories/fs2http/docs/../lib/routes/copyRec.coffee -->



<!-- Start /home/charles/Repositories/fs2http/docs/../lib/routes/rmdir.coffee -->



## Rmdir route
Remove empty directories

> Method: DEL

> Default URL: /fs2http/rmdir



### Params: 

* **String** *path* The path







<!-- End /home/charles/Repositories/fs2http/docs/../lib/routes/rmdir.coffee -->



<!-- Start /home/charles/Repositories/fs2http/docs/../lib/routes/utimes.coffee -->



## Utimes route
Change file last access and modification times

> Method: POST

> Default URL: /fs2http/utimes



### Params: 

* **String** *path* The path 

* **String** *atime* The last access time (see Node.js documentation for format)

* **String** *mtime* The last modification time (see Node.js documentation for format)







<!-- End /home/charles/Repositories/fs2http/docs/../lib/routes/utimes.coffee -->



<!-- Start /home/charles/Repositories/fs2http/docs/../lib/routes/chmodRec.coffee -->



## ChmodRec route
Change file mode bits recursively

> Method: POST

> Default URL: /fs2http/chmodRec



### Params: 

* **String** *path* The path 

* **String** *mode* The new mode







<!-- End /home/charles/Repositories/fs2http/docs/../lib/routes/chmodRec.coffee -->



<!-- Start /home/charles/Repositories/fs2http/docs/../lib/routes/readFile.coffee -->



## ReadFile route
Read a file

> Method: GET

> Default URL: /fs2http/readFile



### Params: 

* **String** *path* The path







<!-- End /home/charles/Repositories/fs2http/docs/../lib/routes/readFile.coffee -->



<!-- Start /home/charles/Repositories/fs2http/docs/../lib/routes/unlink.coffee -->



## Unlink route
Call the unlink function to remove the specified file

> Method: DEL

> Default URL: /fs2http/unlink



### Params: 

* **String** *path* The path 







<!-- End /home/charles/Repositories/fs2http/docs/../lib/routes/unlink.coffee -->



<!-- Start /home/charles/Repositories/fs2http/docs/../lib/routes/rename.coffee -->



## Rename route
Rename a path

> Method: POST

> Default URL: /fs2http/rename



### Params: 

* **String** *path1* The old path

* **String** *path2* The new path







<!-- End /home/charles/Repositories/fs2http/docs/../lib/routes/rename.coffee -->



<!-- Start /home/charles/Repositories/fs2http/docs/../lib/routes/chown.coffee -->



## ChownRec route
change file owner and group

> Method: POST

> Default URL: /fs2http/chown



### Params: 

* **String** *path* The path

* **String** *uid* The new uid

* **String** *gid* The new gid







<!-- End /home/charles/Repositories/fs2http/docs/../lib/routes/chown.coffee -->



<!-- Start /home/charles/Repositories/fs2http/docs/../lib/routes/stat.coffee -->



## Stat route
Display file or file system status

> Method: GET

> Default URL: /fs2http/stat



### Params: 

* **String** *path* The path







<!-- End /home/charles/Repositories/fs2http/docs/../lib/routes/stat.coffee -->



<!-- Start /home/charles/Repositories/fs2http/docs/../lib/routes/rmRec.coffee -->



## RmRec route
Remove files and directories recursively

> Method: DEL

> Default URL: /fs2http/rmRec



### Params: 

* **String** *path* The path







<!-- End /home/charles/Repositories/fs2http/docs/../lib/routes/rmRec.coffee -->



<!-- Start /home/charles/Repositories/fs2http/docs/../lib/routes/symlink.coffee -->



## Symlink route
Make a new name for a file

> Method: POST

> Default URL: /fs2http/symlink



### Params: 

* **String** *link* The destination 

* **String** *path* The path to link







<!-- End /home/charles/Repositories/fs2http/docs/../lib/routes/symlink.coffee -->



<!-- Start /home/charles/Repositories/fs2http/docs/../lib/routes/mkdir.coffee -->



## Mkdir route
Make a directory

> Method: POST

> Default URL: /fs2http/mkdir



### Params: 

* **String** *path* The path

* **String** *mode* The mode (optional, default comes from Node.js)







<!-- End /home/charles/Repositories/fs2http/docs/../lib/routes/mkdir.coffee -->



<!-- Start /home/charles/Repositories/fs2http/docs/../lib/routes/chmod.coffee -->



## Chmod route
Change file mode bits

> Method: POST

> Default URL: /fs2http/chmod



### Params: 

* **String** *path* The path 

* **String** *mode* The new mode







<!-- End /home/charles/Repositories/fs2http/docs/../lib/routes/chmod.coffee -->

