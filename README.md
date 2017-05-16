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
