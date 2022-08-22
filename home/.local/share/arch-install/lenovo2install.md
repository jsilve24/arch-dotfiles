###############
# Pre Install #
###############

# Follow Arch Install Guide at wiki.archlinux.org/title/installation_guide
# Here I only list non-trivial changes/decision for reference

## Prepare installation in in usb live image
# I downloaded iso and signature from here: http://mirror.cs.pitt.edu/archlinux/iso/2022.04.05/
# check key (from existing arch install)
pacman-key -v archlinux...iso.sig
# write iso to usb drive (replace x)
sudo cp archlinux...iso /dev/sdx

# make sure that secure boot is turned off
# press enter at lenovo screen to get boot menu

## Keyboard layout
# default (US) is fine

## verify boot mode

## Connect to the internet ##
iwctl                               # to get an interactive promp
# device list                       # to get device name
# station [device] scan             
# station [device] get-networks     # to get ssid
# station [device] connect [ssid]   # will prompt for password
station wlan0 connect 'Homewood Farm'
exit

ping archlinux.org

## update system clock

## Partition the disks ##
lsblk                      # list devices
fdisk /dev/nvme0n1         # drops into interactive fdisk utility
# create 3 partitions EFI (p1) SWAP (p2) and root partition (p3)
# p1 will be 512M, p2 will be 64 gb (size of ram +2), p3 will be remainder
# Will partition with gpt (works better with UEFI boot mode apparently)
g                          # to create new empty gpt partition table
n                          # to create new partition
[enter]                    # to make it default partition number [1]
[enter]                    # to accept default first sector
+512M                      # to set last sector (e.g., size) of first partition
t                          # to change filesystem type
1                          # to select EFI type
# repeat for other partitions
n
[enter]
[enter]
+64G
t
19  # linux swap
n
[enter]
[enter]
[enter] # remainder of disk
w     # write changes to disk and exit fdisk

## Format Partitions ##
mkfs.fat -F 32 /dev/nvme0n1p1     # format EFI (p1) partition to FAT32
mkfs.ext4 /dev/nvme0n1p3          # format ext4 for (p3) root partition 
mkswap /dev/nvme0n1p2             # format swap partition
lsblk -f   # to check results

## mount the filesystem ##
mount /dev/nvme0n1p3 /mnt               # mount root partition
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot          # mount efi
swapon /dev/nvme0n1p2


###########
# Install #
###########

## Select Mirrors ##
vim /etc/pacman.d/mirrorlist # move geographically close stuff up (within reason)
# I put the arch.mirror.constant.com up top

## pacstrap to install essential packages ##

# Was using an old install image/usb had to do the following before pacstrap
pacman-key --refresh-keys # takes a while next time just create a new install medium

## going with default linux kernel
pacstrap /mnt base linux linux-firmware archlinux-keyring vim sudo

## Configure New System ##

genfstab -U /mnt >> /mnt/etc/fstab ## generate fstab using UUID
less /mnt/etc/fstab ## check results - edit if necessary

## Chroot into new system ##
arch-chroot /mnt

## set the time zone ##
ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
# run hwclock to generate /etc/adjtime 
hwclock --systohc

## Localization ##
vim /etc/locale.gen
# then uncomment en_US.UTF-8 UTF-8
local-gen # to generate locales
vim /etc/locale.conf
# add LANG=en_US.UTF-8

## Network Configuration ##
vim /etc/hostname
# add line lenovoGen4Sil as my hostname
# install networking software
pacman -S networkmanager net-tools inetutils iwd

## Initramfs ##
# nothing done

## Set root password ##
# same as gpg

## Boot Loader and Microcode##
pacman -S grub efibootmgr 
# follow instructions to install grub found in the grub artcle of the arch wiki (under UEFI Systems)
mount /dev/nvme0n1p1 /mnt # yes you are mounting under arch-chroot mounting on a mount... 
# install the grub EFI application grubx64.efi to /mnt/EFI/grub and installs its modules to /boot/grub/x86_64-efi
grub-install --target=x86_64-efi --efi-directory=/mnt --bootloader-id=GRUB
# After the above installation completed, the main GRUB directory is located at /boot/grub/. Note
# that grub-install also tries to create an entry in the firmware boot manager, named GRUB in the
# above example – this will, however, fail if your boot entries are full; use efibootmgr to remove
# unnecessary entries.
# then generate the main configuration file (/boot/grub/grub.cfg)
grub-mkconfig -o /boot/grub/grub.cfg


## Install microcode ##
pacman -S intel-ucode
# add the following to the environment
CONFIG_BLK_DEV_INITRD=Y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=Y
CONFIG_MICROCODE_AMD=y
# remake grub config
grub-mkconfig -o /boot/grub/grub.cfg


## REBOOT AND PRAY ##


#####################
# Post-Installation #
#####################

## login as root 

## setup wifi
systemctl enable NetworkManager
systemctl start NetworkManager
nmtui

## Create new user
pacman -S zsh sudo
useradd -m -s /usr/bin/zsh jds6696
passwd jds6696    # [then set to same as lenovo]
# add user to sudors
EDITOR=vim visudo # in environment 
# then
visudo /etc/sudoers
# uncomment line %wheel ALL=(ALL) ALL to allow sudo for users in group wheel
# uncomment line %sudo ALL=(ALL) ALL to allow sudo for users in group sudo
# then add user to wheel and sudo 
usermod -aG wheel jds6696
usermod -aG sudo jds6696

# then switch to jds6696
su - jds6696

## install other missing packages ##
pacman -Syu # update first
pacman -S xorg-server xorg-xrandr xorg-xinit xorg-xsetroot qutebrowser man git 
# choose man-db from core, jack2 over pipewire-jack, gnu-free-fonts 

## Enable Pacman Parallel Downloads and Parallel Compilation ##
vim /etc/pacman.conf
# under Misc options uncomment or add
ParallelDownloads=5
IloveCandy
Color
# for parallel compilation https://wiki.archlinux.org/title/makepkg
vim /etc/makepkg.conf
# add / uncomment line MAKEFLAGS="-j$(nproc)"

# install yay
pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
# first time use of yay
yay -Y --gendb # generate database for *-git packages that were installed without yay (only run once)
yay -Syu --devel

## Install homeschick and dotfiles ##
pacman -S fzf thefuck
yay -S zoxide
git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
cd ~/.homesick/respos/homeshick/bin/
./homeshick clone https://github.com/jsilve24/arch-dotfiles.git
./homeshick link arch-dotfiles
# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# move my .zshrc back and replace the one writen by oh-my-zsh
# install plugins
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
git clone https://github.com/micrenda/zsh-nohup ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/nohup


# Then Reboot for changes to take effect -- log in with jds6696

## Setup NVIDIA drivers ##
#Posted Here" https://bbs.archlinux.org/viewtopic.php?pid=2022500#p2022500
# Following the reverse prime directions [[https://wiki.archlinux.org/title/PRIME#Reverse_PRIME][reverse prime directions]] was not the solution.
pacman -S fwupd # to get firmware updates
pacman -S udisks2 # to deal with this warning https://github.com/fwupd/fwupd/wiki/PluginFlag:esp-not-found
pacman -S nvidia

# Then ran -- can repeat as needed -- firmware
fwupdmgr get-devices
fwupdmgr refresh
fwupdmgr get-updates
fwupdmgr update # will likely require reboot

## Setup Display Manager ##
yay -S ly
systemctl enable ly.ervice
# configure ly
vim /etc/ly/config.ini
# setup pam login through GnuPG (setup follows readme at: https://github.com/cruegge/pam-gnupg)
yay -S gnupg
# NOTE .gnupg and a bunch of .gpg encoded stuff is in bitwardent under GNUPG Store
# add the following to /etc/pam.d/ly to setup pam-gnupg
auth     optional  pam_gnupg.so store-only
session  optional  pam_gnupg.so
# add to ~/.gnupg/gpg-agent.conf
allow-present-passphrase
# (optional) Also add to ~/.gnupg/gpg-agent
max-cache-ttl 86400
# to have cache timeout after 1 day
# aside: add to ~/.gnupg/gpg-agent to get loopback
# from here: https://vxlabs.com/2021/03/21/gnupg-pinentry-via-the-emacs-minibuffer/
allow-loopback-entry 
# then run
gpgconf --reload gpg-agent
# then run gpg -K --with-keygrip and Write the keygrip for the encryption subkey marked [E] – shown in boldface in the output above – into ~/.pam-gnupg. If you want to unlock multiple keys or subkeys, add all keygrips on separate lines.
# Set the same password for your gpg key and your user account. All pam-gnupg does is to send the password as entered to gpg-agent. It is therefore not compatible with auto-login of any kind; you actually have to type your password for things to work.

## Get cantarell font working on arch ##
# Seems to be a bug in this font on arch -- someone created this AUR package which solves it. 
# Here is the bug report: https://bugs.archlinux.org/task/72212
yay -S cantarell-static-fonts


## Install python ##
pacman -S python-pip

## Setup i3 ##
pacman -S i3-wm i3status xterm dmenu arandr
yay -S caffeine-ng
pacman -S jq # to get i3-navigate-emacs working
pacman -S xdotool

## Setting up Screen Resolution for hiDPI screen ##
# Following instructions here: https://blog.summercat.com/configuring-mixed-dpi-monitors-with-xrandr.html -- did not work
# Laptop screen is 3840x2400
# large external monitor is 2560x1080
# make one large screen 8960 x 4560
# Install Autorandr
# ultimately decided to just downsample built in display to half resolution


# setup dropbox and bitwarden
yay -S dropbox
pacman -S bitwarden bitwarden-cli
pacman -S rsync

## Setup gpg credentials and login manager ## 
# export key from prior system - just copied over .gnupg directory in full

## Setup Github Credentials ##
pacman -S github-cli
gh auth login

## Setup git credential store for other git repos like overleaf ##
# follow these instructions: https://andrearichiardi.com/blog/posts/git-credential-netrc.html

# get the git contributed netrc build
git clone https://github.com/git/git.git
cd git
cd contrib/credential/netrc
make
cp -v git-credential-netrc `$HOME//bin` # on my $PATH
# add the following line to .gitconfig
[credential]
	helper = !/home/jds6696/bin/git-credential-netrc
# note I stored .netrc.gpg in home directory for this and a copy is stored in bitwarden


## Setup Emacs ##
# words for ispell-complete
pacman -S words wordnet-common wordnet-cli aspell aspell-en
yay -S global ctags # global provides gtags

# vterm stuff
yay -s cmake libvterm

# mail stuff
yay -s autoconf automake pkg-config mu java8-openjfx isync
<!-- # Want to install davmail 5.5.1 which I know works  -->
<!-- # Download pkg from here: https://aur.archlinux.org/cgit/aur.git/commit/?h=davmail&id=f2ff7554c3453ed3ea07f4611a6529d7d608863b -->
<!-- tar xvzf aur....tar.gz -->
<!-- cd aur... -->
<!-- makepkg -si -->
<!-- # then select java8-openjfx to install  -->
Follow davmail install instruction from here: 
http://davmail.sourceforge.net/linuxsetup.html
Basically download latest .zip from sourceforge (not the trunk), then uncompress, cd in and ./davmail azul then ./davmail and done...
Should update pkgbuild at some point

# copy ~/.cache/mu to new machine or reinitialize mu store 
mu init --maildir=~/.mail --my-address=jsilve24@gmail.com --my-address=JustinSilverman@psu.edu
mu index

# install dragon drag and drop
yay -S dragon-drop
ln -S /sbin/dragon-drop /home/jds6696/bin/dragon

# install feh
yay -S feh
# TODO: need to set new wallpaper

# install scrot 
yay -S scrot

# install tex
yay -S texlive-science # for algorithm2e package
yay -S texlive-core texlive-fontsextra texlive-latexextra biber texlive-bibtexextra

# install stuff for pdf-tools
yay -S libpng zlib poppler-glib

# install nm-applet
yay -S network-manager-applet

# install fonts and other stuff 
yay -S pandoc ripgrep imagemagick ripgrep-all 
pacman -S perl-image-exiftool # for org-bib-mode
yay -S wget 
yay -S ttf-dejavu ttf-fira-code ttf-hack ttf-jetbrains-mono ttf-iosevka

# install emacs
pacman -S emacs-nativecomp 

## Setup EXWM ## 
# add the following to /usr/share/xsessions/emacs.desktop
[Desktop Entry]
Name=Emacs
Exec=emacs
Type=Application

## Setup KMonad ##
yay -S kmonad-bin
#simlink service files into /etc/systemd/system/kmonad.service
ln kmonad-kinesis.service /etc/systemd/system/kmonad-kinesis.service
ln kmonad-lenovo.service /etc/systemd/system/kmonad-lenovo.service
ln kmonad-sculpt.service /etc/systemd/system/kmonad-sculpt.service
# enable services
systemctl enable kmonad-kinesis.service
systemctl enable kmonad-lenovo.service
systemctl enable kmonad-scult.service

## Setup R ## 
yay -S r tcl tk libgit2 gcc-fortran libxls openmp
# in R do the following
install.packages("rmarkdown")

## Setup Sound ##
yay -S alsa-utils pulseaudio pulseaudio-alsa pamixer
# no microphone detected, tried installing sof-firmware and alsa-ucm-conf from here: https://bbs.archlinux.org/viewtopic.php?id=258633

# TODO: pulseaudio-jack and pulseaudio-bluetooth

## Setup Brightness ## 
# From here: https://github.com/natj/guide-to-configuring-arch-on-lenovo-carbon-x1-gen7
# You can check the current brightness with:
# 
# cat /sys/class/backlight/intel_backlight/brigthness
# and maximum possible brightness (to get a feeling of the scaling) with
# 
# cat /sys/class/backlight/intel_backlight/max_brigthness
# Different machines might have different bl_device so check that intel_backlight exists.
# 
# For the actual brightness control we need to add user to video group in oder to have permission to write to the needed configuration files.
# 
# Add a file /etc/udev/rules.d/backlight.rules with:
# 
# ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"
# ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
# Then
# 
# sudo usermod -aG video jds6696
# After this you have permission to change bl_dev and Fn+F5/F6 should work.
# or better yet install acpilight (I tried version 1.2-2) and then it provides a command xbacklight that works nicely (whereas xorg-xbacklight package did not)
# 
# use xbacklight -set [0-100]
# 
# Ref:
# 
# https://wiki.archlinux.org/index.php/Backlight
# 
# After this reset brightness (between 0 and 512) using
# "sudo echo 350 > /sys/class/backlight/intel_backlight/brightness"

## Setup Printing at Home ##
yay -S cups ## read again
yay -S brother-hl-l2380dw
# ppd file gets installed to /opt/brother/Printers/HLL2380DW/cupswrapper/brother-HLL2380DW-cups-en.ppd
# to get network discovery of printers setup avahi https://wiki.archlinux.org/title/Avahi
yay -S avahi
# install nss-mdns to get local hostname resolution
yay -S nss-mdns 
systemctl enable avahi-daemon.service
systemctl start avahi-daemon.service
# Then, edit the file /etc/nsswitch.conf and change the hosts line to include mdns_minimal [NOTFOUND=return] before resolve and dns:
hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns

# then restart /enable cups.service
systemctl enable cups.service
systemctl start cups.service

# then setup printers under ManagePrinting app
 
## Setup office printer
pacman -S hplip # hp laserjet drivers

## Setup backup suite ##
yay -S borg timeshift
yay -S python-llfuse

## Hide GRUB at Start unless Shift is held down ##
# https://wiki.archlinux.org/title/GRUB/Tips_and_tricks#Hide_GRUB_unless_the_Shift_key_is_held_down
# vim /etc/default/grub
# GRUB_FORCE_HIDDEN_MENU="true"
# 
# then create /etc/grub.d/31_hold_shift (see above link for more details)
# then make it executrable
# then run:  grub-mkconfig -o /boot/grub/grub.cfg
# Turned off as this wasn't working

## Add backup lts kernel ##
pacman -S linux-lts
# then modify grub to fix defaults : added/edited in /etc/default/grub
GRUB_DISABLE_SUBMENU=y # this makes kernel options show up on main grub screen not the sub-menu under advanced options
GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true
# then rebuild 
grub-mkconfig -o /boot/grub/grub.cfg



## Setup touchscreen ##
# TODO

## Assorted other software ##
yay -S libreoffice-still inkscape gimp spotify
yay -S pdfjs # to read pdfs in qutebrowser
pacman -S inotify-tools # used by exwm-qute-edit script
yay -S rstudio-desktop
yay -S xournalpp
pacman -S htop
yay -S pdftd bcprov java-commons-lang # to allow removing passwords from pdf documents
pacman -S unrar

# setup hugo
yay -S hugo
# for lab website sam theme need nmp
pacman -S npm
npm install postcss postcss-cli autoprefixer


# PSU VPN setup
install globalprotect-openconnect from AUR
portal address: secure-connect.psu.edu
Gateway: INTERNAL (select through systemtray icon)

## Debugging hiberation/suspend issues
# on the new lenovo suspend was not working the following fixed it:
# following these instructions: https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Hibernation
# I found that the kernel parameter resume was not set: (check with sysctl -a)
# modified /etc/default/grub and added option between quotes in GRUB_CMDLINE_LINUX_DEFAULT
# find uuid of swap with lsblk -f
resume=UUID=0dbf6a47-9ea4-4379-b46e-fdb6faadf7d1

## debugging lack of boot on arch after update-alternatives
## Add to /etc/default/grub the kernel parameter
## from here https://wiki.archlinux.org/title/NVIDIA#Installation issue with intell cpu and nvidia driver
ibt=off 
# then run 
grub-mkconfig -o /boot/grub/grub.cfg
# relevant bug is tracked here: https://github.com/NVIDIA/open-gpu-kernel-modules/issues/256

## scratch 
## https://github.com/asoroa/ical2org.py 
pip install ical2orgpy

## Setup Wacom
# It should mostly just work on arch: https://wiki.archlinux.org/title/Graphics_tablet
pacman -S xf86-input-wacom # to get the xsetwacom 
