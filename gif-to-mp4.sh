#!/bin/bash

################################################################################
#                                                                              #
# Author: BlueSalt Labs (Luke Sontrop)                                         #
# Name: gif-to-mp4                                                             #
# Version: 1.0                                                                 #
# Date: 2017-05-15                                                             #
# Website: https://github.com/bluesalt-labs/giftomp4                           #
# Description:                                                                 #
# BlueSalt Labs - GIF to MP4                                                   #
# A shell script to convert gifs to MP4 videos                                 #
#                                                                              #
# Requires imagemagick and avconv (libav-tools)                                #
# imagemagick: <https://www.imagemagick.org/script/index.php>                  #
# avconv: <https://libav.org/avconv.html>                                      #
#                                                                              #
# Thanks to Nguyen Sy Thanh Son for the initial information I needed to        #
# write this script <https://sonnguyen.ws/convert-gif-to-mp4-ubuntu/>.         #
#                                                                              #
# Todo:                                                                        #
# * Create a function that outputs a help screen (function output_docs(){}).   #
# * this assumes Ubuntu, i.e. `apt-get`. It'd be cool to detect the OS and     #
#   see if these two libraries are available, as well as output the            #
#   OS-specific command to install.                                            #
# * Create functions for each of the things that happen in here and run all    #
#   of the functions at the end (so we're using local variables).              #
# * It'd be cool if there was a config file that it read so you didn't have    #
#   to specify all the command line arguments every single time it ran.        #
# * If the output file exists, ask if the user wants to overwrite it           #
# * Add an option to run silently                                              #
################################################################################

# Make sure we're NOT root (do I need to do this?)
if (( $EUID == 0 )); then
	echo "Please do not run as root."
	exit
fi

# -- Check Dependencies ------------------------------------------------------ #

# imagemagick must be installed, i.e. `apt-get install imagemagick`
command -v convert >/dev/null 2>&1 || { printf >&2 "imagemagick is required but not installed! You can install it by typing:\n\tsudo apt-get install imagemagick\n"; exit 1; }
#todo: make sure this doesn't log the user out when run. it logged me out when I tried to test it...

# avconv must be installed, i.e. `apt-get install libav-tools`
command -v avconv >/dev/null 2>&1 || { echo >&2 "avconv is required but not installed! You can install it by typing:\n\tsudo apt-get install libav-tools\n"; exit 1; }
#todo: make sure this doesn't log the user out when run. it logged me out when I tried to test it...

# -- End Check Dependencies -------------------------------------------------- #


# -- Create Functions -------------------------------------------------------- #

function output_version() {
	echo "gif-to-mp4 version 1.0"
}

function output_docs() {
	#todo
	output_version
	echo "usage (todo)"
}

function exit_with_error() {
	if [ -z "$1" ]; then
		printf >&2 "Unknown Error. Exiting.\n"; exit 1;
	else
		printf >&2 "$1 Exiting.\n"; exit 1;
	fi
}

# -- End Create Functions ---------------------------------------------------- #


# -- Set Default Variable Values --------------------------------------------- #

cache_dir="$HOME"/gif-to-mp4-cache
save_cache=0
in_gif=""
out_mp4=""


# -- End Set Default Variable Values ----------------------------------------- #

# -- Get command Line Arguments ---------------------------------------------- #

while [[ $# -gt 0 ]]
do
	key="$1"

	case "$key" in
	-v|--version)
		output_version
		exit 0
		;;
	-h|--help)
		output_docs
		exit 0
		;;
	-i|--input)
		in_gif="$2"
		shift
		shift
		;;
	-o|--output)
		out_mp4="$2"
		shift
		shift
		;;
	-c|--cache-dir)
		cache_dir="$2"
		shift
		;;
	-s|--save-cache)
		save_cache=1
		shift
		;;
	*)
		printf "Unknown option '%s'\n" $1
		shift
		;;
	esac
done

# -- End Get Command Line Arguments ------------------------------------------ #

# -- Make Sure Everything Is In Order ---------------------------------------- #

# Check that the input file was specified
if [ "$in_gif" == "" ]; then
	exit_with_error "Must specify an input file."
fi

# Check that the input file exists
if [ ! -e "$in_gif" ]; then
	exit_with_error "Input file '$in_gif' does not exist."
fi

# Check that the input file is actually a gif
in_file_type="$(file -ib "$in_gif")"
if [ "$in_file_type" != "image/gif; charset=binary" ]; then
	exit_with_error "Input file type '$in_file_type' is not valid (must be of type 'image/gif; charset=binary')."
fi

# Make sure the cache directory exists
if [ ! -d "$cache_dir" ]; then
	mkdir "$cache_dir"
	if [ ! -d "$cache_dir" ]; then
		exit_with_error "Could not create the cache directory '$cache_dir'."
	fi
fi

# Set the default output file if it's not specified
if [ "$out_mp4" == "" ]; then
	#out_mp4="$(dirname -z "$in_gif")/"
	out_mp4="${in_gif%.*}.mp4"
fi

# Make sure the output file doesn't exist
if [ -e "$out_mp4" ]; then
	exit_with_error "Output file '$out_mp4' exists."
fi

#todo? Make sure we can write to the output file


# -- End Make Sure Everything Is In Order ------------------------------------ #




# -- Temp Stuff -------------------------------------------------------------- #
# Number of frames in the gif
#identify -format "%n" /var/www/pico.bluesaltlabs.com/public_html/assets/gifs/unplugging-modem.gif

# Length of time each image is displayed in picoseconds (1 picosecond = 0.01 seconds. <http://www.kylesconverter.com/time/centiseconds-to-seconds>)
#identify -format "frame%s.png:%Tcs\n" /var/www/pico.bluesaltlabs.com/public_html/assets/gifs/unplugging-modem.gif
# -- End Temp Stuff ---------------------------------------------------------- #





# Todo: get passed in file name
# Todo: figure out how to have options in input

# Get the number of frames in the video
printf "Calculating number of frames in gif..."
frames="$( identify -format "%n\n" /var/www/pico.bluesaltlabs.com/public_html/assets/gifs/unplugging-modem.gif | awk '{t=($0)} END{print t }' )"
printf "%d frames\n" $frames

# Get the length of the gif in picoseconds
#function get_gif_length { }

printf "Calculating length of gif in picoseconds..."
seconds="$( identify -format "%T\n" /var/www/pico.bluesaltlabs.com/public_html/assets/gifs/unplugging-modem.gif | awk '{t+=($0)} END{print t }' )"
printf "%d picoseconds\n" $seconds

# Calculate the framerate
printf "Calculating framerate..."
framerate=$(( frames / seconds ))
printf "%d fps\n" $framerate

echo "Still working on the actual conversion math. Stay tuned! Exiting."; exit 0;

# Convert gif to png files in temp directory
#convert /var/www/pico.bluesaltlabs.com/public_html/assets/gifs/unplugging-modem.gif /home/luke/gif-cache/frame%d.png
#avconv -r $framerate -i /home/luke/gif-cache/frame%002d.png -qscale 1 test.mp4