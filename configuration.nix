{ config, lib, pkgs, stdenv, ... }:


{
	imports = [ ./hardware-configuration.nix ];

	# Inlined hardware-configuration.nix
	boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "firewire_ohci" "usb_storage" "sd_mod" "sdhci_pci" ];
	boot.kernelModules = [ "kvm-intel" ];
	boot.extraModulePackages = [ ];
	boot.loader.grub.enableCryptodisk = true;
	boot.loader.grub.memtest86.enable = true;
	boot.loader.grub.extraInitrd = "/boot/key-initrd"; # contains /key.bin
	boot.initrd.luks.devices.boot = {
		device = "/dev/disk/by-uuid/e52da0cf-b32c-496f-869f-0d5e059311a2";
		keyFile = "/key.bin";
		fallbackToPassword = true;
	};
	boot.initrd.luks.devices.hdd = {
		device = "/dev/disk/by-uuid/8a22cb74-afee-4ba4-b367-69ed42cd9beb";
		preLVM = true;
		keyFile = "/key.bin";
		fallbackToPassword = true;
	};

	fileSystems."/" = {
		device = "/dev/master/root";
		fsType = "ext4";
	};

	fileSystems."/home" = {
		device = "/dev/master/home";
		fsType = "ext4";
	};

	fileSystems."/boot" = {
		device = "/dev/mapper/boot";
		fsType = "ext4";
	};

	boot.loader.grub.device = "/dev/sda";

	swapDevices = [ { device = "/dev/master/swap"; } ];

	boot.kernelParams = [ "resume=/dev/master/swap" ];
	# end inlined hardware-configuration.nix


	boot.loader.grub.enable = true;
	boot.loader.grub.version = 2;
	boot.kernelPackages = pkgs.linuxPackages_latest_hardened;

	services.xserver.videoDrivers = [ "nouveau" ]; # fuck you nvidia
	hardware.opengl.enable = true;
	hardware.opengl.driSupport = true;

	virtualisation.libvirtd.enable = true;

	networking.wireless.enable = true;

	time.timeZone = "Europe/Moscow";

	nixpkgs.config.packageOverrides = pkgs: {
		# todo: configure vim
	};
	programs.vim.defaultEditor = true;

	environment.systemPackages = with pkgs; [
		wget links file binutils gnupg pciutils hdparm smartmontools hddtemp htop iftop iotop nethogs psmisc
	];

	services.tor.enable = true;

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	programs.mtr.enable = true;
	programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
	programs.zsh = {
		enable = true;
		enableAutosuggestions = true;
		enableCompletion = true;
		interactiveShellInit = "ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=037'"; # future: check mail
		ohMyZsh.enable = true;
		ohMyZsh.plugins = [ ]; # here is the list https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins
		ohMyZsh.theme = "avit";
		syntaxHighlighting.enable = true;
		syntaxHighlighting.highlighters = [ "main" "brackets" ];
		shellInit = ''[ -z "$TMUX" ] && ${pkgs.tmux}/bin/tmux new-session && exit'';
	};

	fonts.fonts = with pkgs; [ font-droid ]; # better than any of the ligature fonts

	# To be reviewed in the future

	# services.openssh.enable = true;

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	services.kmscon.enable = true;

	sound.enable = true;
	hardware.pulseaudio.enable = true;

	services.xserver.enable = true;
	services.xserver.layout = "us,ru";
	services.xserver.xkbOptions = "grp:caps_toggle";

	services.xserver.libinput.enable = true;

	services.xserver.displayManager.lightdm.enable = true;
	services.xserver.windowManager.xmonad.enable = true;
	services.xserver.windowManager.xmonad.enableContribAndExtras = true;

	environment.etc."systemd/sleep.conf".text = lib.mkAfter ''
SuspendMode=suspend
HibernateMode=shutdown
HybridSleepMode=suspend
SuspendState=mem
HibernateState=disk
HybridSleepState=mem
HibernateDelaySec=900 # 15 min
	'';
	services.logind.lidSwitch = "hybrid-sleep";

	services.locate.enable = true;
	services.locate.interval = "hourly";
	services.locate.locate = pkgs.mlocate;

	programs.light.enable = true;

	users.users.d = {
		home = "/home/d";
		createHome = true;
		extraGroups = [ "wheel"  "libvirtd" ];
		useDefaultShell = true;
		packages = with pkgs; with pkgs.gnome3; [
			firefox dconf dconf-editor dmenu git pass virtmanager feh gajim xclip bat qbittorrent weechat mpv evince
			dunst libnotify xcompmgr volnoti
			(sublime3.overrideAttrs (oldAttrs: oldAttrs // { meta = oldAttrs.meta // { license = pkgs.stdenv.lib.licenses.free; }; })) # avoid allowUnfree = true
			(st.overrideAttrs (oldAttrs: rec {
				patches = map fetchpatch [
					{
						url = "https://st.suckless.org/patches/hidecursor/st-hidecursor-0.8.diff";
						sha256 = "1n7dinjfqmra9lv59ly0zfglngg1n1x5qfqnghwqvxkpbfamkcpm";
					}
					{
						url = "https://st.suckless.org/patches/solarized/st-solarized-dark-20180411-041912a.diff";
						sha256 = "01lnrycm3nw02r97mi28fkn21346is7ch41fjxd5164wvvlbr8q7";
					}
				];
			}))
		]; # aiming at zero `nix-env -i`
	};
	users.defaultUserShell = pkgs.zsh;

	# This value determines the NixOS release with which your system is to be
	# compatible, in order to avoid breaking some software such as database
	# servers. You should change this only after NixOS release notes say you
	# should.
	system.nixos.stateVersion = "18.03"; # Did you read the comment?

}
