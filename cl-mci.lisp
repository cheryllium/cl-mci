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

; Use this to set the current song. 
; song needs to be something.mp3
(defun set-song (song) 
  (defparameter *song* song))

; play-song is a helper function. 
(defun play-song () 
  (let ((status 
	 (mcisendstringa 
	  (concatenate 'string 
		       "open " *song* " alias song")
	  "" 0 0)))
    (if (= status 0) 
	1
	(mcisendstringa 
	 (concatenate 'string 
		      "play " *song* "")
	 "" 0 0))))

; Plays the current song. 
; It will keep trying to play it if there is an error, 
; because frequently it will fail for some reason :/ 
; This failure appears to be nondeterministic... 
(defun play () 
  (if *song* 
      (if (= (play-song) 0)
	  0 (play)) 
      "Error: You must first specify a song with SET-SONG."))

; Pauses the current song. 
(defun pause () 
  (mcisendstringa 
   (concatenate 'string "pause " *song*)
   "" 0 0))

; Stops the current song. 
(defun stop () 
  (mcisendstringa 
   (concatenate 'string "stop " *song*)
   "" 0 0))

; Please remember to call this when you're done with a song! 
(defun close-song () 
  (if *song* 
      (mcisendstringa 
       (concatenate 'string "close " *song*)
       "" 0 0)
      nil))