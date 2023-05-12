#!/bin/bash

######################################################################
#                        * . caveman linux! .*                       # 
######################################################################
#      A small school project built by Devin, Bradley and Soham      #
#                         Check us out here!                         #
#                                                                    #
#   ninetyninebytes (devin): https://www.github.com/ninetyninebytes  #
#         guygopher (bradley): https://github.com/guygopher          #
#         S-Panjwani (soham): https://github.com/S-Panjwani          #
######################################################################
#   This project is made with the GNU General Public License v2.0.   #
#            Please read the LICENSE file for the license            #
######################################################################

# !!! CHECK BOTTOM OF SCRIPT FOR NOTES
# !!! CHECK BOTTOM OF SCRIPT FOR NOTES
# !!! CHECK BOTTOM OF SCRIPT FOR NOTES

echo 
cat textlogo.txt
echo
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e "\033[1mCaveman Linux Installer\033[0m"
echo "This will configure Arch Linux with our modifications"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Make sure you read the README.md before continuing."
echo "also, please read the LICENSE file for the license."
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e "\033[1mWARNING: WE ARE NOT RESPONSIBLE FOR DAMAGES TO YOUR COMPUTER.\033[0m"
echo -e "\e[3m(so please make sure you know what you're doing!)\e[0m"
echo
echo "Please choose an option:"
echo
echo "S: Start the Installation"
echo "C: Cancel the Installation"
echo "R: View the README.md file"

while true; do
    read -p "Your Selection [S/C/R]: " scr
    case $scr in
        [Ss]* ) break;;
        [Cc]* ) echo installation cancelled!; exit;;
        [Rr]* ) cat README.md;;
        * ) echo "Please choose a valid selection.";;
    esac
done

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e "\033[1mCONFIRMATION\033[0m"
echo
echo This is a confirmation to install the software
echo WE ARE NOT RESPONSIBLE FOR DAMAGES TO YOUR COMPUTER.

while true; do
    read -p "Do you want to Install? [Y/N]: " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "installation cancelled, please start over."; exit;;
        * ) echo "Please choose a valid option."
    esac
done

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e "\033[1mFINAL CONFIRMATION\033[0m"
echo
echo -e "\033[1mLAST WARNING:\033[0m"
echo -e This the FINAL confirmation to install the software
echo By installng, you acknowledge that we are NOT RESPONSIBLE for damages to your computer,
echo and you have read the README.md file before installing.
echo
echo To Install, please type in "InstallCavemanLinux" and press enter.

VERIFY_PHRASE="InstallCavemanLinux"
read -p "Please enter the phrase to continue: " user_input
if [[ "$user_input" == "$VERIFY_PHRASE" ]]; then
  echo "Starting Installation"

  seconds=10 # are you high 

  while [ $seconds -gt 0 ]
  do
      echo "Seconds remaining [Press Control + C to force quit]: $seconds"
      sleep 1
      seconds=$(( $seconds - 1 ))
  done

  echo "Installation Started!"
  
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo -e "\033[1mMirror Setup\033[0m"
  echo
  echo "please choose a country for your pacman mirrors"
  echo "you are allowed to sepearate each country with commas, and each country must start with a capital letter"
  echo "example: Canada, France"
  read COUNTRY
  pacman -S --noconfirm --needed reflector
  reflector --country $COUNTRY --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist --verbose
  echo done!
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo -e "\033[1mConfiguring Pacman\033[0m"
  echo
  echo "would you like to enable multilib, and set paralell downloads to 5?
  while true; do
    read -p "choose an option [Y/N]: " yn
    case $yn in
        [Yy]* ) sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf; sed -i '/^#.*ParallelDownloads =.*/s/^#//' /etc/pacman.conf; sed -i '/^#.*ParallelDownloads =.*/s/[[:digit:]]*/10/' ~/pacmantest.conf; break;;
        [Nn]* ) echo "additional features will NOT be added, however you can install them yourself later"; break;;
        * ) echo "Please choose a valid option."
    esac
  done
  echo "done!"
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  # select best mirrors and refresh them every week
  echo -e "\033[1msetting up mirror refresh scripts...\033[0m"
  cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
  rm /etc/xdg/reflector/reflector.conf
  echo "--save /etc/pacman.d/mirrorlist" >> /etc/xdg/reflector/reflector.conf
  echo "--country $COUNTRY" >> /etc/xdg/reflector/reflector.conf
  echo "--protocol https" >> /etc/xdg/reflector/reflector.conf
  echo "--latest 10" >> /etc/xdg/reflector/reflector.conf
  echo "--sort rate" >> /etc/xdg/reflector/reflector.conf
  systemctl enable reflector.timer
  echo "mirrors will now be refreshed every week on startup."
  echo "done!"
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  # installing packages
  echo -e "\033[1minstalling packages\033[0m"
  pacman -Syu
  pacman -S --noconfirm xorg xorg-server gnome neofetch firefox vim gnome-tweaks libreoffice-fresh htop git
  echo "done!"
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo -e "\033[1menabling GDM on startup\033[0m"
  systemctl enable gdm.service
  echo "done!"
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo -e "\033[1minstallation complete! rebooting system...\033[0m"

  seconds=10

  while [ $seconds -gt 0 ]
  do
      echo "Seconds remaining: $seconds"
      sleep 1
      reboot
      seconds=$(( $seconds - 1 ))
  done
else
      echo "installation cancelled, please start over."
      exit 1
fi


# NOTES:
# we need to do a lot of testing for the script

# networkmanager stuff
# we can just setup networkmanager and dhcpcd during proper install
# lets make a proper arch installer 
# and we can just make it git clone this and run

# the paralell downloads problem
# apparently the script i made isnt working to set paralell downloads to 10
# i'll probably fix it soon

# TO BE ADDED:
# integrate rock to system
# make exclusive wallpapers
# add colored text (if we have time)
# change /etc/os-release information

# IDEAS:
# maybe use rok over yay?
# if we're going to install yay we still need to make a post logon script
# we can always use profile.d and rm -f it later