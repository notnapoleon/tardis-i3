#!/bin/bash

launch_script () {
	internet_check
}

internet_check () {
	homeuser=$USER

  echo '  _____ _   ___ ___ ___ ___     _ ____'
 echo ' |_   _/_\ | _ \   \_ _/ __|___(_)__ /'
   echo '   | |/ _ \|   / |) | |\__ \___| ||_ \'
   echo '   |_/_/ \_\_|_\___/___|___/   |_|___/'
	echo 
	echo "Free Software licensed under the GNU General Public License 3.0"	
   echo && sleep 2	
	read -p "Can you confirm you're connected to the internet and want to go ahead with the installer? [y/n] " internet
	if [ $internet == 'y' ] || [ $internet == 'Y' ]
	then
		root_check	
	else
		end_script	
	fi
}

# Requesting root privileges
root_check () {
	if [ $USER != 'root' ]
	then
		aur_setup	
	else
		end_script	
	fi
}

root_error () {
	echo
	echo "Install failed, please do not run script as sudo."
	exit
}

pacman_update () {
	sudo pacman -Sy && pacman -Syu
       	pacman_install	
}

aur_setup () {
	pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
	pacman_update
}

# If something goes wrong with the script
end_script () {
	echo
	echo "An error has occurred and the script was unable to install successfully."
	exit
}

# Installing packages
pacman_install () {
	pacman -S i3 dmenu polybar ttf-fira-code arc-icon-theme lxappearance thunar materia-gtk-theme ttf-fira-sans sddm noto-fonts noto-fonts-cjk nitrogen wireplumber pipewire pipewire-pulse pavucontrol xfce4-terminal network-manager-applet chromium vim --noconfirm --needed
	systemctl enable sddm
	wm_customise
}

# Setup for WM and utilities
wm_customise () {
	rm -rf /home/$homeuser/.config
	mkdir -p /home/$homeuser/.config/i3 && mkdir -p /home/$homeuser/.config/polybar
	cp -r config/i3/config /home/$homeuser/.config/i3
	cp -r config/polybar/config.ini /home/$homeuser/.config/polybar
	cp -r 'config/gtk-2.0' /home/$homeuser/.config
	cp -r 'config/gtk-3.0' /home/$homeuser/.config
	end_of_install
}

end_of_install () {
	clear
	echo "Installation complete, please restart your computer."
}

# What causes the script to run
launch_script
