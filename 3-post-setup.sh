#!/usr/bin/env bash
echo -ne "
-------------------------------------------------------------------------
   █████╗ ██████╗  ██████╗██╗  ██╗
  ██╔══██╗██╔══██╗██╔════╝██║  ██║
  ███████║██████╔╝██║     ███████║
  ██╔══██║██╔══██╗██║     ██╔══██║
  ██║  ██║██║  ██║╚██████╗██║  ██║
  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
-------------------------------------------------------------------------
                    Automated Arch Linux Installer
                        SCRIPTHOME: ArchInstall
-------------------------------------------------------------------------

Final Setup and Configurations
GRUB EFI Bootloader Install & Check
"
source /root/ArchInstall/setup.conf
genfstab -U / >>/etc/fstab
if [[ -d "/sys/firmware/efi" ]]; then
  grub-install --efi-directory=/boot ${DISK}
fi
# set kernel parameter for decrypting the drive
if [[ "${FS}" == "luks" ]]; then
  sed -i "s%GRUB_CMDLINE_LINUX_DEFAULT=\"%GRUB_CMDLINE_LINUX_DEFAULT=\"cryptdevice=UUID=${encryped_partition_uuid}:ROOT root=/dev/mapper/ROOT %g" /etc/default/grub
fi

echo -e "Installing CyberRe Grub theme..."
THEME_DIR="/boot/grub/themes"
THEME_NAME=catppuccin-grub-theme
echo -e "Creating the theme directory..."
mkdir -p "${THEME_DIR}/${THEME_NAME}"
echo -e "Copying the theme..."
cd ${HOME}/ArchInstall
cp -a ${THEME_NAME}/* ${THEME_DIR}/${THEME_NAME}
echo -e "Backing up Grub config..."
cp -an /etc/default/grub /etc/default/grub.bak
echo -e "Setting the theme as the default..."
grep "GRUB_THEME=" /etc/default/grub 2>&1 >/dev/null && sed -i '/GRUB_THEME=/d' /etc/default/grub
echo "GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"" >>/etc/default/grub
grep "GRUB_GFXMODE=" /etc/default/grub 2>&1 >/dev/null && sed -i '/GRUB_GFXMODE=/d' /etc/default/grub
echo "GRUB_GFXMODE=1920x1080" >>/etc/default/grub
echo -e "Updating grub..."
grub-mkconfig -o /boot/grub/grub.cfg
echo -e "All set!"

echo -ne "
-------------------------------------------------------------------------
                    Enabling Login Display Manager
-------------------------------------------------------------------------
"
echo "disabled"
#systemctl enable sddm.service
echo -ne "
-------------------------------------------------------------------------
                    Setting up SDDM Theme
-------------------------------------------------------------------------
"
echo "disabled"
# cat <<EOF >/etc/sddm.conf
# [Theme]
# Current=Nordic
# EOF

echo -ne "
-------------------------------------------------------------------------
                    Enabling Essential Services
-------------------------------------------------------------------------
"
systemctl enable cups.service
ntpd -qg
systemctl enable ntpd.service
systemctl disable dhcpcd.service
systemctl stop dhcpcd.service
systemctl enable NetworkManager.service
systemctl enable bluetooth
echo -ne "
-------------------------------------------------------------------------
                    Cleaning
-------------------------------------------------------------------------
"
# Remove no password sudo rights
# sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
# Add sudo rights
# sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

rm -r /root/ArchInstall
rm -r /home/$USERNAME/ArchInstall

# Replace in the same state
cd $pwd
