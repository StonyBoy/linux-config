#no = Global default, although everything should be something
#fi = Normal file
#di = Directory
#ln = Symbolic link. If you set this to 'target' instead of a numerical value, the colour is as for the file pointed to.
#pi = Named pipe
#do = Door
#bd = Block device
#cd = Character device
#or = Symbolic link pointing to a non-existent file
#so = Socket
#su = File that is setuid (u+s)
#sg = File that is setgid (g+s)
#tw = Directory that is sticky and other-writable (+t,o+w)
#ow = Directory that is other-writable (o+w) and not sticky
#st = Directory with the sticky bit set (+t) and not other-writable
#ex = Executable file (i.e. has 'x' set in permissions)
#mi = Non-existent file pointed to by a symbolic link (visible when you type ls -l)
#lc = Opening terminal code
#rc = Closing terminal code
#ec = Non-filename text
#*.extension   Every file using this extension e.g. *.jpg

#0   = default colour
#1   = bold
#4   = underlined
#5   = flashing text
#7   = reverse field
#30  = black
#31  = red
#32  = green
#33  = yellow
#34  = blue
#35  = purple
#36  = cyan
#37  = grey
#40  = black background
#41  = red background
#42  = green background
#43  = orange background
#44  = blue background
#45  = purple background
#46  = cyan background
#47  = grey background
#90  = dark grey
#91  = light red
#92  = light green
#93  = yellow
#94  = light blue
#95  = light purple
#96  = turquoise
#97  = white
#100 = dark grey background
#101 = light red background
#102 = light green background
#103 = yellow background
#104 = light blue background
#105 = light purple background
#106 = turquoise background
#106 = white background


#ls colors
export LS_COLORS="no=00"                       # no effects as default
export LS_COLORS=$LS_COLORS:"fi=00"            # no efects on files as default
if [ -z $TERM_DARK_BACKGROUND ]
then
    export LS_COLORS=$LS_COLORS:"di=00;30"         # directory is black
else
    export LS_COLORS=$LS_COLORS:"di=01;33"         # directory is bold and orange
fi
export LS_COLORS=$LS_COLORS:"ln=00;36"         # symlinks  is bold and cyan
export LS_COLORS=$LS_COLORS:"pi=100;35"        # fifo      is ?    and ?
export LS_COLORS=$LS_COLORS:"so=100;35"        # socktes   is bold and purple
export LS_COLORS=$LS_COLORS:"do=100;35"        # door

if [ -z $TERM_DARK_BACKGROUND ]
then
    export LS_COLORS=$LS_COLORS:"bd=100;34;01"     # block dev is bold, darkgray bg and blue
else
    export LS_COLORS=$LS_COLORS:"bd=100;33;01"     # block dev is bold, darkgray bg and orange
fi
export LS_COLORS=$LS_COLORS:"cd=100;32;01"     # char  dev is bold, darkgray bg and green
export LS_COLORS=$LS_COLORS:"or=01;05;37;41"   # symlink pointing to non-existing file
export LS_COLORS=$LS_COLORS:"mi=01;05;37;41"   # symlink pointing to non-existing file
export LS_COLORS=$LS_COLORS:"su=37;41"         # setuid file
export LS_COLORS=$LS_COLORS:"sg=30;43"         # setgid file
export LS_COLORS=$LS_COLORS:"tw=30;42"         # sticky other-writable file
export LS_COLORS=$LS_COLORS:"ow=97;42"         # other writable file
export LS_COLORS=$LS_COLORS:"st=37;44"         # sticky dir

if [ -z $TERM_DARK_BACKGROUND ]
then
export LS_COLORS=$LS_COLORS:"ex=35"
else
export LS_COLORS=$LS_COLORS:"ex=01;32"         # executables is bold and green
fi


#archives is red and bold
export LS_COLORS=$LS_COLORS:"*.tar=01;31"
export LS_COLORS=$LS_COLORS:"*.tgz=01;31"
export LS_COLORS=$LS_COLORS:"*.svgz=01;31"
export LS_COLORS=$LS_COLORS:"*.arj=01;31"
export LS_COLORS=$LS_COLORS:"*.taz=01;31"
export LS_COLORS=$LS_COLORS:"*.lzh=01;31"
export LS_COLORS=$LS_COLORS:"*.lzma=01;31"
export LS_COLORS=$LS_COLORS:"*.zip=01;31"
export LS_COLORS=$LS_COLORS:"*.z=01;31"
export LS_COLORS=$LS_COLORS:"*.Z=01;31"
export LS_COLORS=$LS_COLORS:"*.dz=01;31"
export LS_COLORS=$LS_COLORS:"*.gz=01;31"
export LS_COLORS=$LS_COLORS:"*.bz2=01;31"
export LS_COLORS=$LS_COLORS:"*.bz=01;31"
export LS_COLORS=$LS_COLORS:"*.tbz2=01;31"
export LS_COLORS=$LS_COLORS:"*.tz=01;31"
export LS_COLORS=$LS_COLORS:"*.deb=01;31"
export LS_COLORS=$LS_COLORS:"*.rpm=01;31"
export LS_COLORS=$LS_COLORS:"*.jar=01;31"
export LS_COLORS=$LS_COLORS:"*.rar=01;31"
export LS_COLORS=$LS_COLORS:"*.ace=01;31"
export LS_COLORS=$LS_COLORS:"*.zoo=01;31"
export LS_COLORS=$LS_COLORS:"*.cpio=01;31"
export LS_COLORS=$LS_COLORS:"*.7z=01;31"
export LS_COLORS=$LS_COLORS:"*.rz=01;31"

#media files is bold purple
export LS_COLORS=$LS_COLORS:"*.jpg=01;35"
export LS_COLORS=$LS_COLORS:"*.jpeg=01;35"
export LS_COLORS=$LS_COLORS:"*.gif=01;35"
export LS_COLORS=$LS_COLORS:"*.bmp=01;35"
export LS_COLORS=$LS_COLORS:"*.pbm=01;35"
export LS_COLORS=$LS_COLORS:"*.pgm=01;35"
export LS_COLORS=$LS_COLORS:"*.ppm=01;35"
export LS_COLORS=$LS_COLORS:"*.tga=01;35"
export LS_COLORS=$LS_COLORS:"*.xbm=01;35"
export LS_COLORS=$LS_COLORS:"*.xpm=01;35"
export LS_COLORS=$LS_COLORS:"*.tif=01;35"
export LS_COLORS=$LS_COLORS:"*.tiff=01;35"
export LS_COLORS=$LS_COLORS:"*.png=01;35"
export LS_COLORS=$LS_COLORS:"*.svg=01;35"
export LS_COLORS=$LS_COLORS:"*.mng=01;35"
export LS_COLORS=$LS_COLORS:"*.pcx=01;35"
export LS_COLORS=$LS_COLORS:"*.mov=01;35"
export LS_COLORS=$LS_COLORS:"*.mpg=01;35"
export LS_COLORS=$LS_COLORS:"*.mpeg=01;35"
export LS_COLORS=$LS_COLORS:"*.m2v=01;35"
export LS_COLORS=$LS_COLORS:"*.mkv=01;35"
export LS_COLORS=$LS_COLORS:"*.ogm=01;35"
export LS_COLORS=$LS_COLORS:"*.mp4=01;35"
export LS_COLORS=$LS_COLORS:"*.m4v=01;35"
export LS_COLORS=$LS_COLORS:"*.mp4v=01;35"
export LS_COLORS=$LS_COLORS:"*.vob=01;35"
export LS_COLORS=$LS_COLORS:"*.qt=01;35"
export LS_COLORS=$LS_COLORS:"*.nuv=01;35"
export LS_COLORS=$LS_COLORS:"*.wmv=01;35"
export LS_COLORS=$LS_COLORS:"*.asf=01;35"
export LS_COLORS=$LS_COLORS:"*.rm=01;35"
export LS_COLORS=$LS_COLORS:"*.rmvb=01;35"
export LS_COLORS=$LS_COLORS:"*.flc=01;35"
export LS_COLORS=$LS_COLORS:"*.avi=01;35"
export LS_COLORS=$LS_COLORS:"*.fli=01;35"
export LS_COLORS=$LS_COLORS:"*.gl=01;35"
export LS_COLORS=$LS_COLORS:"*.dl=01;35"
export LS_COLORS=$LS_COLORS:"*.xcf=01;35"
export LS_COLORS=$LS_COLORS:"*.xwd=01;35"
export LS_COLORS=$LS_COLORS:"*.yuv=01;35"
export LS_COLORS=$LS_COLORS:"*.aac=00;35"
export LS_COLORS=$LS_COLORS:"*.au=00;35"
export LS_COLORS=$LS_COLORS:"*.flac=00;35"
export LS_COLORS=$LS_COLORS:"*.mid=00;35"
export LS_COLORS=$LS_COLORS:"*.midi=00;35"
export LS_COLORS=$LS_COLORS:"*.mka=00;35"
export LS_COLORS=$LS_COLORS:"*.mp3=00;35"
export LS_COLORS=$LS_COLORS:"*.mpc=00;35"
export LS_COLORS=$LS_COLORS:"*.ogg=00;35"
export LS_COLORS=$LS_COLORS:"*.ra=00;35"
export LS_COLORS=$LS_COLORS:"*.wav=00;35"

if [ -z $TERM_DARK_BACKGROUND ]
then
#text documents is gray
export LS_COLORS=$LS_COLORS:"*.pdf=00;90"
export LS_COLORS=$LS_COLORS:"*.ps=00;90"
export LS_COLORS=$LS_COLORS:"*.txt=00;90"
export LS_COLORS=$LS_COLORS:"*.patch=00;90"
export LS_COLORS=$LS_COLORS:"*.diff=00;90"
export LS_COLORS=$LS_COLORS:"*.log=00;90"
export LS_COLORS=$LS_COLORS:"*.tex=00;90"
export LS_COLORS=$LS_COLORS:"*.doc=00;90"

else
#text documents is gray
export LS_COLORS=$LS_COLORS:"*.pdf=00;37"
export LS_COLORS=$LS_COLORS:"*.ps=00;37"
export LS_COLORS=$LS_COLORS:"*.txt=00;37"
export LS_COLORS=$LS_COLORS:"*.patch=00;37"
export LS_COLORS=$LS_COLORS:"*.diff=00;37"
export LS_COLORS=$LS_COLORS:"*.log=00;37"
export LS_COLORS=$LS_COLORS:"*.tex=00;37"
export LS_COLORS=$LS_COLORS:"*.doc=00;37"
fi

if [ -z $TERM_DARK_BACKGROUND ]
then
    export LS_COLORS=$LS_COLORS
else
    #source code is orange
    export LS_COLORS=$LS_COLORS:"*.h=00;33"
    export LS_COLORS=$LS_COLORS:"*.hxx=00;33"
    export LS_COLORS=$LS_COLORS:"*.cxx=00;33"
    export LS_COLORS=$LS_COLORS:"*.cpp=00;33"
    export LS_COLORS=$LS_COLORS:"*.c=00;33"
    export LS_COLORS=$LS_COLORS:"*.vhdl=00;33"
    export LS_COLORS=$LS_COLORS:"*.vhd=00;33"
    export LS_COLORS=$LS_COLORS:"*.java=00;33"
    export LS_COLORS=$LS_COLORS:"*.rb=33"
    export LS_COLORS=$LS_COLORS:"*.pl=33"
    export LS_COLORS=$LS_COLORS:"*.py=33"
fi

