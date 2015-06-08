# cl-mci
Little Lisp mp3 library

This simple library has functions that allow you to open, play, pause, stop, and close mp3 files. 
Simply load the file in order to use it. The following are descriptions of the functions included, 
most of which shoud be pretty self-explanatory. 

### set-song

Pass a file name to set-song to set the current song. 

### play, pause, stop

These functions take no arguments and play, pause, or stop the current song. 

### close-song 

Remember to call this when you are done with a file in order to close it properly. 
