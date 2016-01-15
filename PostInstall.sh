#!/bin/sh
clear

# Create a secure tmp directory
tmp=${TMPDIR-/tmp}
	tmp=$tmp/postinstall.$RANDOM.$RANDOM.$RANDOM.$$ # Use a random name so it's secure
	(umask 077 && mkdir "$tmp") || { # Another security precaution
		echo "Could not create temporary directory! Exiting." 1>&2
		exit 1
	}

distro=$(lsb_release -c | cut -f2)
targetDistro=trusty
if [ "$distro" != "$targetDistro" ]; then
  echo "Wrong Distribution!"
  echo "You are using $distro, this script was made for $targetDistro."
  exit 1
fi
#use sudo rights for the whole script
sudo -s <<YEAH

clear

echo ------------------
echo "Welcome to YEAH"
echo ------------------
echo "   "
sleep 2

trap "rm -rf $tmp" EXIT # Delete tmp files on exit

# Add all the repositories
echo "Adding Repositories"
(
#Enable partner repository
sed -i "/^# deb .*partner/ s/^# //" /etc/apt/sources.list
wget -q http://apt.last.fm/last.fm.repo.gpg -O- | sudo apt-key add -
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
add-apt-repository ppa:tomahawk/ppa -y
add-apt-repository ppa:tualatrix/ppa -y
add-apt-repository ppa:noobslab/indicators -y
add-apt-repository ppa:amandeepgrewal/notifyosdconfig -y
add-apt-repository ppa:danjaredg/jayatana -y
add-apt-repository ppa:paolorotolo/copy -y
add-apt-repository ppa:nilarimogard/webupd8 -y
add-apt-repository ppa:webupd8team/haguichi -y
add-apt-repository ppa:webupd8team/y-ppa-manager -y
add-apt-repository ppa:yunnxx/gnome3 -y
add-apt-repository ppa:shutter/ppa -y
apt-add-repository ppa:moka/stable -y
apt-add-repository ppa:numix/ppa -y
apt-add-repository -y "deb http://apt.last.fm/debian precise main"
apt-add-repository -y "deb http://repository.spotify.com stable non-free" && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59
apt-add-repository ppa:danielrichter2007/grub-customizer -y
apt-add-repository ppa:me-davidsansome/clementine -y
apt-add-repository ppa:webupd8team/sublime-text-3 -y
apt-add-repository ppa:bmeznarsic/icon-themes -y
apt-add-repository ppa:jd-team/jdownloader -y
apt-add-repository ppa:thefanclub/grive-tools -y
apt-add-repository ppa:atareao/atareao -y
apt-add-repository ppa:yorba/ppa -y
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Updating System"
(
apt-get update
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing VLC"
(
apt-get -y install vlc
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Geary"
(
apt-get install geary -y
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing GIMP"
(
apt-get -y install gimp
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing My Weather Indicator"
(
apt-get install my-weather-indicator -y
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Grive Tools"
(
apt-get install grive-tools -y
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Spotify"
(
apt-get -y install spotify-client-qt
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Grub Customizer"
(
apt-get -y install grub-customizer
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Clementine"
(
apt-get -y install clementine
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Sublime 3"
(
apt-get -y install sublime-text-installer
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing JDownloader"
(
apt-get install jdownloader-installer -y
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Dropbox"
(
apt-get -y install nautilus-dropbox
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Chrome"
(
apt-get install google-chrome-stable -y
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Pacifica"
(
wget http://fc00.deviantart.net/fs71/f/2013/305/9/6/pacifica_icons_by_bokehlicia-d6nn5lb.zip -O $tmp/pacifica.zip
unzip $tmp/pacifica.zip -d $tmp
mv $tmp/Pacifica /usr/share/icons/
mv $tmp/Pacifica-U /usr/share/icons/
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Nitrux"
(
apt-get install elementary-nitrux-icons -y
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Numix-Circle"
(
apt-get -y install numix-icon-theme-circle
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Moka"
(
apt-get -y install faba-icon-theme moka-icon-theme faba-mono-icons
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Tomahawk"
(
apt-get -y install tomawawk
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Ubuntu Tweak"
(
apt-get -y install ubuntu-tweak
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing indicators(notifications, privacy, sound switcher, syspeek, pushbullet)"
(
apt-get -y install indicator-notifications indicator-privacy indicator-sound-switcher syspeek nautilus-pushbullet pushbullet-indicator pushbullet-commons
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Notify-OSD config"
(
apt-get -y install notifyosdconfig
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Java Menus"
(
apt-get -y install jayatana libjayatana libjayatana-java libjayatanaag libjayatanaag-java
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Copy"
(
apt-get -y install copy
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Copy"
(
apt-get -y install copy
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing ppa-stuff"
(
apt-get -y install audacious puddletag y-ppa-manager shutter haguichi haguichi-appindicator audaciousnotifier
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing stuff I like"
(
apt-get -y install banshee skype synaptic qbittorrent compizconfig-settings-manager unity-tweak-tool asunder openjdk-7-jdk dconf-editor menulibre pavucontrol gdebi gnome-sushi avidemux nautilus-open-terminal gtk2-engines-murrine:i386 gtk2-engines-pixbuf:i386
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

#Install nvidia drivers
notify-send "Eh, hazme caso, maldito"
read -p "Do you want to install nvidia drivers?" rc
case "$rc" in
y*) apt-get install nvidia-331 nvidia-settings -y
n*) echo "Fuk U"
esac

echo "Cleaning up"
(
apt-get -y autoremove
apt-get -y autoclean
apt-get -y clean
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Upgrading old packages"
(
apt-get -y upgrade
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing file archiving resources"
(
apt-get install unace rar unrar p7zip-rar p7zip zip unzip sharutils uudeview mpack arj cabextract file-roller -y
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Ubuntu Restricted Extra"
(
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
apt-get install ubuntu-restricted-extras -y
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Vertex"
(
wget -O $tmp/vertex.zip http://fc05.deviantart.net/fs70/f/2014/257/6/9/vertex___theme_by_horst3180-d7s7ycx.zip
unzip $tmp/vertex.zip 'Gnome-3.10_Ubuntu-14.04/*' -d $tmp
mv $tmp/Gnome-3.10_Ubuntu-14.04/Vertex /usr/share/themes/Vertex
mv $tmp/Gnome-3.10_Ubuntu-14.04/Vertex-Light /usr/share/themes/Vertex-Light
chmod -R 755 /usr/share/themes/Vertex
chmod -R 755 /usr/share/themes/Vertex-Light
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Installing Numix"
(
apt-get install numix-gtk-theme -y
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m'; # Hide all output

echo "Tweaking tweaking..."
#Show all startup apps
sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop

#Disable apport
sed -i 's/enabled=1/enabled=0/g' /etc/default/apport

#echo "Rebooting in 10 Seconds, CTRL + C to cancel!"
#sleep 10
#shutdown -r now

YEAH
notify-send "Pisha!" "Que ehto ya ehtá inhtalao"
exit 0
