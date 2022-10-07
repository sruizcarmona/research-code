# delay 3 means 100/3 fps --> 33.3 fps (pymol sets it up to 30, so quite similar)
convert -delay 3 -loop 0 *.png movie_small.gif


# export from pymol with good resolution
# https://pymol.org/tutorials/moviemaking/
# https://infoheap.com/create-animated-gif-using-mac-preview/
# https://stackoverflow.com/questions/20126812/mac-terminal-create-animated-gif-from-png-files
