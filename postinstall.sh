#!/bin/sh
clear

this_path=$(readlink -f $0)
dir_name=`dirname ${this_path}`

# Create a secure tmp directory
tmp=${TMPDIR-/tmp}
    tmp=$tmp/postinstall.$RANDOM.$RANDOM.$RANDOM.$$ # Use a random name so it's secure
    (umask 077 && mkdir "$tmp") || { # Another security precaution
        echo "Could not create temporary directory! Exiting." 1>&2
        exit 1
    }

if [ $(tput colors) ]; then # Checks if terminal supports colors
    red="\e[31m"
    green="\e[32m"
    endcolor="\e[39m"
fi

distro=$(lsb_release -c | cut -f2)

# Create dir to install some programs
homedir=$HOME
mkdir "$homedir/Programs"

# use sudo rights for the whole script
#sudo -s <<YEAH

clear

echo ------------------
echo "Welcome to YEAH"
echo ------------------
echo " "
sleep 2

trap "rm -rf $tmp" EXIT # Delete tmp files on exit

echo "Upgrading old packages"
(
apt-get update -y
apt-get upgrade -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

# Add all the repositories
echo "Adding Repositories"
(

if [ "$distro" = trusty ]; then
    # Java menues integrated
    add-apt-repository ppa:danjaredg/jayatana -y 
    # Clementine
    apt-add-repository ppa:me-davidsansome/clementine -y
    # Libreoffice
    add-apt-repository ppa:libreoffice/ppa -y
    # Brightness fix for Trusty
    add-apt-repository ppa:nrbrtx/sysvinit-backlight -y
    # qBittorrent
    add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y
    # Indicator keylock
    add-apt-repository ppa:tsbarnes/indicator-keylock -y
    # Ubuntu make
    add-apt-repository ppa:ubuntu-desktop/ubuntu-make -y
    # Ubuntu sdk
    add-apt-repository ppa:ubuntu-sdk-team/ppa -y
    # Geary
    apt-add-repository ppa:yorba/ppa -y
elif [ "$distro" = xenial ]; then
    # Arc theme (Seems it will be updated for xenial)
    sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_15.10/ /' >> /etc/apt/sources.list.d/arc-theme.list"
    wget http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_15.10/Release.key
    apt-key add - < Release.key  
    # Birdie
    add-apt-repository ppa:birdie-team/stable -y
    # Yosembiance
    add-apt-repository ppa:bsundman/themes -y
    # Lollypop
    add-apt-repository ppa:gnumdk/lollypop -y
fi

# Enable partner repository
sed -i "/^# deb .*partner/ s/^# //" /etc/apt/sources.list
# Google Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
# Spotify
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
# Config notify-osd (Seems it will be updated for xenial)
add-apt-repository ppa:amandeepgrewal/notifyosdconfig -y
# My weather indicator and stuff
apt-add-repository ppa:atareao/atareao -y
# Grub customizer (Seems it will be updated for xenial)
apt-add-repository ppa:danielrichter2007/grub-customizer -y
# Rhythmbox plugins (alternative ui)
add-apt-repository ppa:fossfreedom/rhythmbox-plugins -y
# Dolphin emulator (Seems it will be updated for xenial)
add-apt-repository ppa:glennric/dolphin-emu -y
# JDownloader (Seems it will be updated for xenial)
apt-add-repository ppa:jd-team/jdownloader -y
# Libretro and retroarch
add-apt-repository ppa:libretro/stable -y
# Simplescreenrecorder (Seems it will be updated for xenial)
add-apt-repository ppa:maarten-baert/simplescreenrecorder -y
# (Seems it will be updated for xenial)
add-apt-repository ppa:nilarimogard/webupd8 -y
# openjdk with fontfix (Seems it will be updated for xenial)
add-apt-repository ppa:no1wantdthisname/openjdk-fontfix -y
# Numix themes and icons
apt-add-repository ppa:numix/ppa -y
# Copy (Seems it will be updated for xenial)
add-apt-repository ppa:paolorotolo/copy -y
# x265 codec (Seems it will be updated for xenial)
add-apt-repository ppa:strukturag/libde265 -y
# Ubuntu Tweak (Seems it will be updated for xenial)
add-apt-repository ppa:tualatrix/ppa -y
# Wine
add-apt-repository ppa:ubuntu-wine/ppa -y
# Atom text editor
add-apt-repository ppa:webupd8team/atom -y
# Brackets text editor
add-apt-repository ppa:webupd8team/brackets -y
# Hamachi gui (Seems it will be updated for xenial)
add-apt-repository ppa:webupd8team/haguichi -y
# Sublime text 3 
apt-add-repository ppa:webupd8team/sublime-text-3 -y
# Tor browser
add-apt-repository ppa:webupd8team/tor-browser -y
# PPA manager
add-apt-repository ppa:webupd8team/y-ppa-manager -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Updating System"
(
apt-get update 
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

if [ "$distro" = trusty ]; then
    echo "Installing Brightness fix"
    (
    apt-get install sysvinit-backlight -y
    ) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

    echo "Installing Java Menus"
    (
    apt-get install jayatana libjayatana libjayatana-java libjayatanaag libjayatanaag-java -y
    ) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

    echo "Installing indicator keylock"
    (
    apt-get install indicator-keylock -y
    ) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

elif [ "$distro" = xenial ]; then
    echo "Installing Vertex, Arc and Yosembiance themes"
    (
    apt-get install arc-theme vertex-theme -y
    ) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

    echo "Installing Birdie"
    (
    apt-get install birdie -y
    ) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

    echo "Installing Lollypop"
    (
    apt-get install lollypop -y
    ) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

fi

echo "Installing Ubuntu Restricted Extra"
(
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
apt-get install ubuntu-restricted-extras -y
/usr/share/doc/libdvdread4/install-css.sh
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing ubuntu make"
(
apt-get install ubuntu-make -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing gaming stuff (Steam, emulators, etc"
(
apt-get install steam retroarch dolphin-emu-master -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing Rhythmbox plugins"
(
apt-get install rhythmbox-plugin-alternative-toolbar -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing simplescreenrecorder"
(
apt-get install simplescreenrecorder -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing Libreoffice breeze and sifr"
(
apt-get install libreoffice-style-breeze libreoffice-style-sifr -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing Geary"
(
apt-get install geary -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing GIMP"
(
apt-get install gimp -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing music and video stuff"
(
apt-get install asunder clementine banshee spotify-client vlc audacious puddletag soundconverter -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing downloading stuff"
(
apt-get install jdownloader-installer qbittorrent filezilla -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing web browsers"
(
apt-get install google-chrome-stable chromium-browser chromium-codecs-ffmpeg-extra adobe-flashplugin -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing config stuff"
(
apt-get install ubuntu-tweak notifyosdconfig y-ppa-manager grub-customizer unity-tweak-tool compizconfig-settings-manager dconf-editor menulibre pavucontrol -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing developing stuff (Compilers, java, text editors, etc)"
(
apt-get install build-essential openjdk-8-jdk sublime-text-installer ruby ubuntu-sdk atom brackets terminator -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing indicators(syspeek, my-weather-indicator, indicator-cpufreq)"
(
apt-get install syspeek indicator-cpufreq my-weather-indicator -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing stuff I like"
(
apt-get install copy haguichi haguichi-appindicator gnome-sushi avidemux nautilus-open-terminal -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing skype"
(
apt-get install skype gtk2-engines-murrine:i386 gtk2-engines-pixbuf:i386 -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing apt stuff"
(
apt-get install synaptic gdebi -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

# Install nvidia drivers
#notify-send "Eh, hazme caso, maldito"
#read -p "Do you want to install nvidia drivers?" rc
#case "$rc" in
#y*) apt-get install nvidia-340 nvidia-settings -y
#n*) echo "Fuk U"
#esac

echo "Installing file archiving resources"
(
apt-get install unace rar unrar p7zip-rar p7zip zip unzip sharutils uudeview mpack arj cabextract file-roller -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing Nylas N1"
(
wget -O $tmp/d.deb https://edgehill.nylas.com/download?platform=linux-deb
dpkg -i $tmp/d.deb
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing Numix themes and icons"
(
apt-get install numix-gtk-theme numix-icon-theme-circle -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Cleaning up"
(
apt-get autoremove -y
apt-get autoclean -y
apt-get clean -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Tweaking tweaking..."
(
# Show all startup apps
sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop

# Change mouse icon theme to elementary
mv elementary /usr/share/icons/
sed -i 's/DMZ-White/elementary/g' /usr/share/icons/default/index.theme
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

YEAH

echo "Installing Firefox dev, Idea, Unity3D and Android Studio"
(
mkdir "$homedir/Programs/firefox-dev"
umake web firefox-dev "$homedir/Programs/firefox-dev"
mkdir "$homedir/Programs/android"
umake android "$homedir/Programs/android"
mkdir "$homedir/Programs/idea"
umake ide idea "$homedir/Programs/idea"
mkdir "$homedir/Programs/unity3d"
umake games unity3d "$homedir/Programs/unity3d"
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing Telegram desktop"
(
wget -O $tmp/telegram.tar.xz https://tdesktop.com/linux
cd $tmp
tar xf telegram.tar.xz
mv Telegram $homedir/Programs/
cd $dir_name
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing cleanup soundmenu"
(
# This would run on startup and eliminate music player from music indicator when it is not running
place=$homedir/Programs/cleanup_soundmenu.py
sed -i "s~placepathhere~$place~g" cleanup.desktop
mv cleanup_soundmenu.py $homedir/Programs/
mv cleanup.desktop $homedir/.config/autostart/
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "More tweaking tweaking..."
(
if [ "$distro" = trusty ]; then
    # Disable overlay scrollbars in trusty
    gsettings set com.canonical.desktop.interface scrollbar-mode normal
fi

# Turn gedit into programming mode
gsettings set org.gnome.gedit.preferences.editor auto-indent true
gsettings set org.gnome.gedit.preferences.editor bracket-matching true
gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
gsettings set org.gnome.gedit.preferences.editor display-right-margin true
gsettings set org.gnome.gedit.preferences.editor highlight-current-line true
gsettings set org.gnome.gedit.preferences.editor scheme 'oblivion'

# Disable apport
sed -i 's/enabled=1/enabled=0/g' /etc/default/apport

# Change gtk and icon theme
gsettings set org.gnome.desktop.interface gtk-theme 'Numix'
gsettings set org.gnome.desktop.wm.preferences theme 'Numix'
gsettings set org.gnome.desktop.interface icon-theme 'Numix-circle'
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

#echo "Rebooting in 10 Seconds, CTRL + C to cancel!"
#sleep 10
#shutdown -r now

notify-send "Post install script" "All done sir!"
exit 0
