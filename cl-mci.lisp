(require 'asdf)
(asdf:oos 'asdf:load-op :cffi)

(cffi:define-foreign-library winmm 
    (t (:default "winmm")))
(cffi:use-foreign-library winmm)

(cffi:defctype mcierror :int)
(cffi:defcfun "mciSendStringA" mcierror 
  (msg :string) (ret :string) 
  (a :int) (b :int))

(defparameter *song* nil)

; Helper function that calls mcisendstringa
(defun mci-send-string (command) 
  (mcisendstringa 
   (concatenate 'string command " " *song*) 
   "" 0 0))

; Use this to set the current song. 
; song needs to be something.mp3
(defun set-song (song) 
  (setf *song* song))

; play-song is a helper function. 
(defun play-song () 
  (let ((status 
	 (mci-send-string "open")))
    (if (zerop status) 
	1
	(mci-send-string "play"))))

; Plays the current song. 
; It will keep trying to play it if there is an error, 
; because frequently it will fail for some reason :/ 
; This failure appears to be nondeterministic... 
(defun play () 
  (if *song* 
      (if (zerop (play-song))
	  0 
	  (play)) 
      "Error: You must first specify a song with SET-SONG."))

; Pauses the current song. 
(defun pause () 
  (mci-send-string "pause"))

; Stops the current song. 
(defun stop () 
  (mci-send-string "stop"))

; Please remember to call this when you're done with a song! 
(defun close-song () 
  (if *song* 
      (mci-send-string "close")
      nil))