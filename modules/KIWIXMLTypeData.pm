#================
# FILE          : KIWIXMLTypeData.pm
#----------------
# PROJECT       : OpenSUSE Build-Service
# COPYRIGHT     : (c) 20012 SUSE LLC
#               :
# AUTHOR        : Robert Schweikert <rjschwei@suse.com>
#               :
# BELONGS TO    : Operating System images
#               :
# DESCRIPTION   : This module represents the data contained in the KIWI
#               : configuration file marked with the <type> element.
#               :
#               : The type has no reference to any child objects, such
#               : as <pxedeploy> or <systemdisk>. The parent - child
#               : relationship is a construct at the XML data structure level.
#               : This design eliminates lengthy call chains such as
#               : XML -> type -> config -> getSomething
#               :
# STATUS        : Development
#----------------
package KIWIXMLTypeData;
#==========================================
# Modules
#------------------------------------------
use strict;
use warnings;
use Scalar::Util qw /looks_like_number/;
require Exporter;

#==========================================
# Exports
#------------------------------------------
our @EXPORT_OK = qw ();

#==========================================
# Constructor
#------------------------------------------
sub new {
	# ...
	# Create the KIWIXMLTypeData object
	# ---
	#==========================================
	# Object setup
	#------------------------------------------
	my $this  = {};
	my $class = shift;
	bless $this,$class;
	#==========================================
	# Module Parameters
	#------------------------------------------
	my $kiwi = shift;
	my $init = shift;
	#==========================================
	# Argument checking and object data store
	#------------------------------------------
	$this->{kiwi} = $kiwi;
	if ($init && ref($init) ne 'HASH') {
		my $msg = 'Expecting a hash ref as second argument if provided';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	if ($init) {
		# Check for unsupported entries
		my %supported = map { ($_ => 1) } qw(
			boot bootkernel bootloader bootpartsize bootprofile
			boottimeout checkprebuilt compressed devicepersistency
			editbootconfig filesystem flags format fsmountoptions
			fsnocheck fsreadonly fsreadwrite hybrid hybridpersistent image
			installboot installiso installprovidefailsafe installstick
			kernelcmdline luks primary ramonly vga volid
		);
		for my $key (keys %{$init}) {
			if (! $supported{$key} ) {
				my $msg = 'Unsupported option in initialization structure '
					. "found '$key'";
				$kiwi -> error($msg);
				$kiwi -> failed();
				return;
			}
		}
		if (! $this -> __isValidInit($init)) {
			return;
		}
		$this->{boot}                   = $init->{boot};
		$this->{bootkernel}             = $init->{bootkernel};
		$this->{bootloader}             = $init->{bootloader};
		$this->{bootpartsize}           = $init->{bootpartsize};
		$this->{bootprofile}            = $init->{bootprofile};
		$this->{boottimeout}            = $init->{boottimeout};
		$this->{checkprebuilt}          = $init->{checkprebuilt};
		$this->{compressed}             = $init->{compressed};
		$this->{devicepersistency}      = $init->{devicepersistency};
		$this->{editbootconfig}         = $init->{editbootconfig};
		$this->{filesystem}             = $init->{filesystem};
		$this->{flags}                  = $init->{flags};
		$this->{format}                 = $init->{format};
		$this->{fsmountoptions}         = $init->{fsmountoptions};
		$this->{fsnocheck}              = $init->{fsnocheck};
		$this->{fsreadonly}             = $init->{fsreadonly};
		$this->{fsreadwrite}            = $init->{fsreadwrite};
		$this->{hybrid}                 = $init->{hybrid};
		$this->{hybridpersistent}       = $init->{hybridpersistent};
		$this->{image}                  = $init->{image};
		$this->{installboot}            = $init->{installboot};
		$this->{installiso}             = $init->{installiso};
		$this->{installprovidefailsafe} = $init->{installprovidefailsafe};
		$this->{installstick}           = $init->{installstick};
		$this->{kernelcmdline}          = $init->{kernelcmdline};
		$this->{luks}                   = $init->{luks};
		$this->{primary}                = $init->{primary};
		$this->{ramonly}                = $init->{ramonly};
		$this->{vga}                    = $init->{vga};
		$this->{volid}                  = $init->{volid};
	}
	# Set default values
	if (! $this->{bootloader} ) {
		$this->{bootloader} = 'grub';
	}
	if (! $this->{installprovidefailsafe} ) {
	$this->{installprovidefailsafe} = 'true';
	}
	return $this;
}

#==========================================
# getBootImageDescript
#------------------------------------------
sub getBootImageDescript {
	# ...
	# Return the configured boot image description
	# ---
	my $this = shift;
	return $this->{boot};
}

#==========================================
# getBootKernel
#------------------------------------------
sub getBootKernel {
	# ...
	# Return the configured bootkernel
	# ---
	my $this = shift;
	return $this->{bootkernel};
}

#==========================================
# getBootLoader
#------------------------------------------
sub getBootLoader {
	# ...
	# Return the configured bootloader
	# ---
	my $this = shift;
	return $this->{bootloader};
}

#==========================================
# getBootPartitionSize
#------------------------------------------
sub getBootPartitionSize {
	# ...
	# Return the configured bootpartition size
	# ---
	my $this = shift;
	return $this->{bootpartsize};
}

#==========================================
# getBootProfile
#------------------------------------------
sub getBootProfile {
	# ...
	# Return the configured bootprofile
	# ---
	my $this = shift;
	return $this->{bootprofile};
}

#==========================================
# getBootTimeout
#------------------------------------------
sub getBootTimeout {
	# ...
	# Return the configured boot timeout
	# ---
	my $this = shift;
	return $this->{boottimeout};
}

#==========================================
# getCheckPrebuilt
#------------------------------------------
sub getCheckPrebuilt {
	# ...
	# Return the configuration for the pre built boot image check
	# ---
	my $this = shift;
	return $this->{checkprebuilt};
}

#==========================================
# getCompressed
#------------------------------------------
sub getCompressed {
	# ...
	# Return the configuration for compressed image generation
	# ---
	my $this = shift;
	return $this->{compressed};
}

#==========================================
# getDevicePersistent
#------------------------------------------
sub getDevicePersistent {
	# ...
	# Return the configuration for the device persistency method
	# ---
	my $this = shift;
	return $this->{devicepersistency};
}

#==========================================
# getEditBootConfig
#------------------------------------------
sub getEditBootConfig {
	# ...
	# Return the path to the script to modify the boot configuration
	# ---
	my $this = shift;
	return $this->{editbootconfig};
}

#==========================================
# getFilesystem
#------------------------------------------
sub getFilesystem {
	# ...
	# Return the configured filesystem
	# ---
	my $this = shift;
	return $this->{filesystem};
}

#==========================================
# getFlags
#------------------------------------------
sub getFlags {
	# ...
	# Return the configuration for the fags setting
	# ---
	my $this = shift;
	return $this->{flags};
}

#==========================================
# getFormat
#------------------------------------------
sub getFormat {
	# ...
	# Return the format for the virtual image
	# ---
	my $this = shift;
	return $this->{format};
}

#==========================================
# getFSMountOptions
#------------------------------------------
sub getFSMountOptions {
	# ...
	# Return the file system mount options
	# ---
	my $this = shift;
	return $this->{fsmountoptions};
}

#==========================================
# getFSNoCheck
#------------------------------------------
sub getFSNoCheck {
	# ...
	# Return the value for the fscheck flag
	# ---
	my $this = shift;
	return $this->{fsnocheck};
}

#==========================================
# getFSReadOnly
#------------------------------------------
sub getFSReadOnly {
	# ...
	# Return the filesystem for read only access
	# ---
	my $this = shift;
	return $this->{fsreadonly};
}

#==========================================
# getFSReadWrite
#------------------------------------------
sub getFSReadWrite {
	# ...
	# Return the filesystem for read write access
	# ---
	my $this = shift;
	return $this->{fsreadwrite};
}

#==========================================
# getHybrid
#------------------------------------------
sub getHybrid {
	# ...
	# Return the flag value to indicate a hybrid image
	# ---
	my $this = shift;
	return $this->{hybrid};
}

#==========================================
# getHybridPersistent
#------------------------------------------
sub getHybridPersistent {
	# ...
	# Return the flag value indicating whether or not persistent storage
	# is included in the hybrid image
	# ---
	my $this = shift;
	return $this->{hybridpersistent};
}

#==========================================
# getImageType
#------------------------------------------
sub getImageType {
	# ...
	# Return the image type
	# ---
	my $this = shift;
	return $this->{image};
}

#==========================================
# getInstallBoot
#------------------------------------------
sub getInstallBoot {
	# ...
	# Return the option configured for the initial boot selection
	# ---
	my $this = shift;
	return $this->{installboot};
}

#==========================================
# getInstallFailsafe
#------------------------------------------
sub getInstallFailsafe {
	# ...
	# Return the value indicating whether the boot menu should have a
	# failsfe entry or not
	# ---
	my $this = shift;
	return $this->{installprovidefailsafe}
}

#==========================================
# getInstallIso
#------------------------------------------
sub getInstallIso {
	# ...
	# Return the value indicating whether or not an ISO image should be
	# created as install media
	# ---
	my $this = shift;
	return $this->{installiso};
}

#==========================================
# getInstallStick
#------------------------------------------
sub getInstallStick {
	# ...
	# Return the value indicating whether or not an USB stick image
	# should be created for installation
	# ---
	my $this = shift;
	return $this->{installstick};
}

#==========================================
# getKernelCmdOpts
#------------------------------------------
sub getKernelCmdOpts {
	# ...
	# Return the configured kernel command line options
	# ---
	my $this = shift;
	return $this->{kernelcmdline};
}

#==========================================
# getLucksPass
#------------------------------------------
sub getLucksPass {
	# ...
	# Return the configured luks password for the filesystem encryption
	# ---
	my $this = shift;
	return $this->{luks};
}

#==========================================
# getPrimary
#------------------------------------------
sub getPrimary {
	# ...
	# Return the flag indicating if this type is marked default
	# ---
	my $this = shift;
	return $this->{primary};
}

#==========================================
# getRAMOnly
#------------------------------------------
sub getRAMOnly {
	# ...
	# Return the flag indicating whether overlay file system writes
	# take place in RAM only
	# ---
	my $this = shift;
	return $this->{ramonly};
}

#==========================================
# getVGA
#------------------------------------------
sub getVGA {
	# ...
	# Return the vga settings for the kernel command line
	# ---
	my $this = shift;
	return $this->{vga};
}

#==========================================
# getVolID
#------------------------------------------
sub getVolID {
	# ...
	# Return the volume ID for an ISO image
	# ---
	my $this = shift;
	return $this->{volid};
}

#==========================================
# setBootImageDescript
#------------------------------------------
sub setBootImageDescript {
	# ...
	# Set the configuration for the boot image description
	# ---
	my $this  = shift;
	my $bootD = shift;
	if (! $bootD ) {
		my $kiwi = $this->{kiwi};
		my $msg = 'setBootImageDescript: no boot description given, retaining '
			. 'current data.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	$this->{boot} = $bootD;
	return $this;
}

#==========================================
# setBootKernel
#------------------------------------------
sub setBootKernel {
	# ...
	# Set the configuration for the bootkernel
	# ---
	my $this  = shift;
	my $bootK = shift;
	if (! $bootK ) {
		my $kiwi = $this->{kiwi};
		my $msg = 'setBootKernel: no boot kernel given, retaining '
			. 'current data.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	$this->{bootkernel} = $bootK;
	return $this;
}

#==========================================
# setBootLoader
#------------------------------------------
sub setBootLoader {
	# ...
	# Set the configuration for the  bootloader
	# ---
	my $this  = shift;
	my $bootL = shift;
	if (! $this -> __isValidBootloader($bootL, 'setBootLoader') ) {
		return;
	}
	$this->{bootloader} = $bootL;
	return $this;
}

#==========================================
# setBootPartitionSize
#------------------------------------------
sub setBootPartitionSize {
	# ...
	# Set the configuration for the  bootpartition size
	# ---
	my $this = shift;
	my $size = shift;
	if (! $size ) {
		my $kiwi = $this->{kiwi};
		my $msg = 'setBootPartitionSize: no size given, retaining current '
			. 'data.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	$this->{bootpartsize} = $size;
	return $this;
}

#==========================================
# setBootProfile
#------------------------------------------
sub setBootProfile {
	# ...
	# Set the configuration for the bootprofile
	# ---
	my $this = shift;
	my $prof = shift;
	if (! $prof ) {
		my $kiwi = $this->{kiwi};
		my $msg = 'setBootProfile: no profile given, retaining '
			. 'current data.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	$this->{bootprofile} = $prof;
	return $this;
}

#==========================================
# setBootTimeout
#------------------------------------------
sub setBootTimeout {
	# ...
	# Set the configuration for the  boot timeout
	# ---
	my $this = shift;
	my $time = shift;
	if (! $time) {
		my $kiwi = $this->{kiwi};
		my $msg = 'setBootTimeout: no timeout value given, retaining '
			. 'current data.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	$this->{boottimeout} = $time;
	return $this;
}

#==========================================
# setCheckPrebuilt
#------------------------------------------
sub setCheckPrebuilt {
	# ...
	# Set the configuration for the pre built boot image check
	# ---
	my $this  = shift;
	my $check = shift;
	my %settings = ( attr   => 'checkprebuilt',
					value  => $check,
					caller => 'setCheckPrebuilt'
				);
	return $this -> __setBoolean(\%settings);
}

#==========================================
# setCompressed
#------------------------------------------
sub setCompressed {
	# ...
	# Set the configuration for compressed image generation
	# ---
	my $this = shift;
	my $comp = shift;
	my %settings = ( attr   => 'compressed',
					value  => $comp,
					caller => 'setCompressed'
				);
	return $this -> __setBoolean(\%settings);
}

#==========================================
# setDevicePersistent
#------------------------------------------
sub setDevicePersistent {
	# ...
	# Set the configuration for the device persistency method
	# ---
	my $this = shift;
	my $devP = shift;
	if (! $this -> __isValidDevPersist($devP, 'setDevicePersistent') ) {
		return;
	}
	$this->{devicepersistency} = $devP;
	return $this;
}

#==========================================
# setEditBootConfig
#------------------------------------------
sub setEditBootConfig {
	# ...
	# Set the path to the script to modify the boot configuration
	# ---
	my $this  = shift;
	my $confE = shift;
	if (! $confE ) {
		my $kiwi = $this->{kiwi};
		my $msg = 'setEditBootConfig: no config script given, retaining '
			. 'current data.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	$this->{editbootconfig} = $confE;
	return $this;
}

#==========================================
# setFilesystem
#------------------------------------------
sub setFilesystem {
	# ...
	# Set the configuration for the  filesystem
	# ---
	my $this = shift;
	my $fs   = shift;
	if (! $this -> __isValidFilesystem($fs , 'setFilesystem') ) {
		return;
	}
	$this->{filesystem} = $fs;
	return $this;
}

#==========================================
# setFlags
#------------------------------------------
sub setFlags {
	# ...
	# Set the configuration for the fags setting
	# ---
	my $this  = shift;
	my $flags = shift;
	if (! $this -> __isValidFlags($flags, 'setFlags') ) {
		return;
	}
	$this->{flags} = $flags;
	return $this;
}

#==========================================
# setFormat
#------------------------------------------
sub setFormat {
	# ...
	# Set the format for the virtual image
	# ---
	my $this   = shift;
	my $format = shift;
	if (! $this -> __isValidFormat($format, 'setFormat') ) {
		return;
	}
	$this->{format} = $format;
	return $this;
}

#==========================================
# setFSMountOptions
#------------------------------------------
sub setFSMountOptions {
	# ...
	# Set the file system mount options
	# ---
	my $this = shift;
	my $opts = shift;
	if (! $opts ) {
		my $kiwi = $this->{kiwi};
		my $msg = 'setFSMountOptions: no mount options given, retaining '
			. 'current data.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	$this->{fsmountoptions} = $opts;
	return $this;
}

#==========================================
# setFSNoCheck
#------------------------------------------
sub setFSNoCheck {
	# ...
	# Set the value for the fscheck flag
	# ---
	my $this  = shift;
	my $check = shift;
	my %settings = ( attr   => 'fsnocheck',
					value  => $check,
					caller => 'setFSNoCheck'
				);
	return $this -> __setBoolean(\%settings);
}

#==========================================
# setFSReadOnly
#------------------------------------------
sub setFSReadOnly {
	# ...
	# Set the filesystem for read only access
	# ---
	my $this = shift;
	my $fs   = shift;
	if (! $this -> __isValidFilesystem($fs , 'setFSReadOnly') ) {
		return;
	}
	$this->{fsreadonly} = $fs;
	return $this;
}

#==========================================
# setFSReadWrite
#------------------------------------------
sub setFSReadWrite {
	# ...
	# Set the filesystem for read write access
	# ---
	my $this = shift;
	my $fs   = shift;
	if (! $this -> __isValidFilesystem($fs , 'setFSReadWrite') ) {
		return;
	}
	$this->{fsreadwrite} = $fs;
	return $this;
}

#==========================================
# setHybrid
#------------------------------------------
sub setHybrid {
	# ...
	# Set the flag value to indicate a hybrid image
	# ---
	my $this   = shift;
	my $hybrid = shift;
	my %settings = ( attr   => 'hybrid',
					value  => $hybrid,
					caller => 'setHybrid'
				);
	return $this -> __setBoolean(\%settings);
}

#==========================================
# setHybridPersistent
#------------------------------------------
sub setHybridPersistent {
	# ...
	# Set the flag value indicating whether or not persistent storage
	# is included in the hybrid image
	# ---
	my $this = shift;
	my $hybridP = shift;
	my %settings = ( attr   => 'hybridpersistent',
					value  => $hybridP,
					caller => 'setHybridPersistent'
				);
	return $this -> __setBoolean(\%settings);
}

#==========================================
# setImageType
#------------------------------------------
sub setImageType {
	# ...
	# Set the image type
	# ---
	my $this = shift;
	my $type = shift;
	if (! $this -> __isValidImage($type, 'setImageType') ) {
		return;
	}
	$this->{image} = $type;
	return $this;
}

#==========================================
# setInstallBoot
#------------------------------------------
sub setInstallBoot {
	# ...
	# Set the option configuration for the  for the initial boot selection
	# ---
	my $this = shift;
	my $opt  = shift;
	if (! $this -> __isValidInstBoot($opt, 'setInstallBoot') ) {
		return;
	}
	$this->{installboot} = $opt;
	return $this;
}

#==========================================
# setInstallFailsafe
#------------------------------------------
sub setInstallFailsafe {
	# ...
	# Set the value indicating whether the boot menu should have a
	# failsfe entry or not
	# ---
	my $this  = shift;
	my $instF = shift;
	my %settings = ( attr   => 'installprovidefailsafe',
					value  => $instF,
					caller => 'setInstallFailsafe'
				);
	return $this -> __setBoolean(\%settings);
}

#==========================================
# setInstallIso
#------------------------------------------
sub setInstallIso {
	# ...
	# Set the value indicating whether or not an ISO image should be
	# created as install media
	# ---
	my $this  = shift;
	my $instI = shift;
	my %settings = ( attr   => 'installiso',
					value  => $instI,
					caller => 'setInstallIso'
				);
	return $this -> __setBoolean(\%settings);
}

#==========================================
# setInstallStick
#------------------------------------------
sub setInstallStick {
	# ...
	# Set the value indicating whether or not an USB stick image
	# should be created for installation
	# ---
	my $this = shift;
	my $instS = shift;
	my %settings = ( attr   => 'installstick',
					value  => $instS,
					caller => 'setInstallStick'
				);
	return $this -> __setBoolean(\%settings);
}

#==========================================
# setKernelCmdOpts
#------------------------------------------
sub setKernelCmdOpts {
	# ...
	# Set the configuration for the  kernel command line options
	# ---
	my $this = shift;
	my $opt  = shift;
	if (! $opt ) {
		my $kiwi = $this->{kiwi};
		my $msg = 'setKernelCmdOpts: no options given, retaining '
			. 'current data.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	$this->{kernelcmdline} = $opt;
	return $this;
}

#==========================================
# setLucksPass
#------------------------------------------
sub setLucksPass {
	# ...
	# Set the configuration for the luks password for the filesystem encryption
	# ---
	my $this = shift;
	my $pass = shift;
	if (! $pass ) {
		my $kiwi = $this->{kiwi};
		my $msg = 'setLucksPass: no password given, retaining '
			. 'current data.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	$this->{luks} = $pass;
	return $this;
}

#==========================================
# setPrimary
#------------------------------------------
sub setPrimary {
	# ...
	# Set the flag indicating if this type is marked default
	# ---
	my $this = shift;
	my $prim = shift;
	my %settings = ( attr   => 'primary',
					value  => $prim,
					caller => 'setPrimary'
				);
	return $this -> __setBoolean(\%settings);
}

#==========================================
# setRAMOnly
#------------------------------------------
sub setRAMOnly {
	# ...
	# Set the flag indicating whether overlay file system writes
	# take place in RAM only
	# ---
	my $this = shift;
	my $ramO = shift;
	my %settings = ( attr   => 'ramonly',
					value  => $ramO,
					caller => 'setRAMOnly'
				);
	return $this -> __setBoolean(\%settings);
}

#==========================================
# setVGA
#------------------------------------------
sub setVGA {
	# ...
	# Set the vga settings for the kernel command line
	# ---
	my $this = shift;
	my $vga  = shift;
	if (! $vga ) {
		my $kiwi = $this->{kiwi};
		my $msg = 'setVGA: no VGA value given, retaining '
			. 'current data.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	$this->{vga} = $vga;
	return $this;
}

#==========================================
# setVolID
#------------------------------------------
sub setVolID {
	# ...
	# Set the volume ID for an ISO image
	# ---
	my $this  = shift;
	my $volID = shift;
	if (! $volID ) {
		my $kiwi = $this->{kiwi};
		my $msg = 'setVolID: no volume ID given, retaining '
			. 'current data.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	$this->{volid} = $volID;
	return $this;
}

#==========================================
# Private helper methods
#------------------------------------------
#==========================================
# __checkBools
#------------------------------------------
sub __checkBools {
	# ...
	# Check all the boolean values in the ctor initialization hash
	# to verify if the values are valid.
	# ---
	my $this = shift;
	my $init = shift;
	my @boolAttrs = qw (checkprebuilt compressed fsnocheck hybrid
						hybridpersistent installiso installprovidefailsafe
						installstick primary ramonly
					);
	for my $attr (@boolAttrs) {
		if (! $this -> __isValidBool($init->{$attr}) ) {
			my $kiwi = $this->{kiwi};
			my $msg = "Unrecognized value for boolean '$attr' in "
				. 'initialization hash, expecting "true" or "false".';
			$kiwi -> error($msg);
			$kiwi -> failed();
			return;
		}
	}
	return 1;
}

#==========================================
# __isValidBool
#------------------------------------------
sub __isValidBool {
	# ...
	# Verify that the given boolean is set with a recognized value
	# true, false, or undef (undef maps to false
	# ---
	my $this = shift;
	my $bVal = shift;
	if (! $bVal || $bVal eq 'false' || $bVal eq 'true') {
		return 1;
	}
	return;
}

#==========================================
# __isValidBootloader
#------------------------------------------
sub __isValidBootloader {
	# ...
	# Verify that the given bootloader is supported
	# ---
	my $this   = shift;
	my $bootL  = shift;
	my $caller = shift;
	my $kiwi = $this->{kiwi};
	if (! $caller ) {
		my $msg = 'Internal error __isValidBootloader called without '
			. 'call origin argument.';
		$kiwi -> info($msg);
		$kiwi -> oops();
	}
	if (! $bootL ) {
		my $msg = "$caller: no bootloader specified, retaining current data.";
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	my %supported = map { ($_ => 1) } qw(
		extlinux grub grub2 syslinux zipl yaboot uboot
	);
	if (! $supported{$bootL} ) {
		my $msg = "$caller: specified bootloader '$bootL' is not supported.";
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	return 1;
}

#==========================================
# __isValidDevPersist
#------------------------------------------
sub __isValidDevPersist {
	# ...
	# Verify that the given device persistency setting is supported
	# ---
	my $this   = shift;
	my $devP  = shift;
	my $caller = shift;
	my $kiwi = $this->{kiwi};
	if (! $caller ) {
		my $msg = 'Internal error __isValidDevPersist called without '
			. 'call origin argument.';
		$kiwi -> info($msg);
		$kiwi -> oops();
	}
	if (! $devP ) {
		my $msg = "$caller: no device persistency specified, retaining "
			. 'current data.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	my %supported = map { ($_ => 1) } qw(
		by-uuid by-label by-path
	);
	if (! $supported{$devP} ) {
		my $msg = "$caller: specified device persistency '$devP' is not "
			. 'supported.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	return 1;
}

#==========================================
# __isValidFilesystem
#------------------------------------------
sub __isValidFilesystem {
	# ...
	# Verify that the given filesystem is supported
	# ---
	my $this   = shift;
	my $fileS  = shift;
	my $caller = shift;
	my $kiwi = $this->{kiwi};
	if (! $caller ) {
		my $msg = 'Internal error __isValidFilesystem called without '
			. 'call origin argument.';
		$kiwi -> info($msg);
		$kiwi -> oops();
	}
	if (! $fileS ) {
		my $msg = "$caller: no filesystem specified, retaining "
			. 'current data.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	my %supported = map { ($_ => 1) } qw(
		btrfs clicfs ext2 ext3 ext4 reiserfs squashfs xfs
	);
	if (! $supported{$fileS} ) {
		my $msg = "$caller: specified filesystem '$fileS' is not "
			. 'supported.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	return 1;
}

#==========================================
# __isValidFlags
#------------------------------------------
sub __isValidFlags {
	# ...
	# Verify that the given flags value is supported
	# ---
	my $this   = shift;
	my $flag   = shift;
	my $caller = shift;
	my $kiwi = $this->{kiwi};
	if (! $caller ) {
		my $msg = 'Internal error __isValidFlags called without '
			. 'call origin argument.';
		$kiwi -> info($msg);
		$kiwi -> oops();
	}
	if (! $flag ) {
		my $msg = "$caller: no flags argument specified, retaining "
			. 'current data.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	my %supported = map { ($_ => 1) } qw(
		clic compressed clic_udf seed
	);
	if (! $supported{$flag} ) {
		my $msg = "$caller: specified flags value '$flag' is not "
			. 'supported.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	return 1;
}

#==========================================
# __isValidFormat
#------------------------------------------
sub __isValidFormat {
	# ...
	# Verify that the given format value is supported
	# ---
	my $this   = shift;
	my $format = shift;
	my $caller = shift;
	my $kiwi = $this->{kiwi};
	if (! $caller ) {
		my $msg = 'Internal error __isValidFormat called without '
			. 'call origin argument.';
		$kiwi -> info($msg);
		$kiwi -> oops();
	}
	if (! $format ) {
		my $msg = "$caller: no format argument specified, retaining "
			. 'current data.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	my %supported = map { ($_ => 1) } qw(
		ec2 ovf ova qcow2 vmdk vhd vhd-fixed
	);
	if (! $supported{$format} ) {
		my $msg = "$caller: specified format '$format' is not "
			. 'supported.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	return 1;
}

#==========================================
# __isValidImage
#------------------------------------------
sub __isValidImage {
	# ...
	# Verify that the given image type value is supported
	# ---
	my $this   = shift;
	my $image  = shift;
	my $caller = shift;
	my $kiwi = $this->{kiwi};
	if (! $caller ) {
		my $msg = 'Internal error __isValidImage called without '
			. 'call origin argument.';
		$kiwi -> info($msg);
		$kiwi -> oops();
	}
	if (! $image ) {
		my $msg = "$caller: no image argument specified, retaining "
			. 'current data.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	my %supported = map { ($_ => 1) } qw(
		btrfs clicfs cpio ext2 ext3 ext4 iso oem product pxe reiserfs
		split squashfs tbz vmx xfs
	);
	if (! $supported{$image} ) {
		my $msg = "$caller: specified image '$image' is not "
			. 'supported.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	return 1;
}

#==========================================
# __isValidInstBoot
#------------------------------------------
sub __isValidInstBoot {
	# ...
	# Verify that the given installboot value is supported
	# ---
	my $this   = shift;
	my $instB  = shift;
	my $caller = shift;
	my $kiwi = $this->{kiwi};
	if (! $caller ) {
		my $msg = 'Internal error __isValidInstBoot called without '
			. 'call origin argument.';
		$kiwi -> info($msg);
		$kiwi -> oops();
	}
	if (! $instB ) {
		my $msg = "$caller: no installboot argument specified, retaining "
			. 'current data.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	my %supported = map { ($_ => 1) } qw(
		failsafe-install harddisk install
	);
	if (! $supported{$instB} ) {
		my $msg = "$caller: specified installboot option '$instB' is not "
			. 'supported.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	return 1;
}

#==========================================
# __isValidInit
#------------------------------------------
sub __isValidInit {
	# ...
	# Verify that the initialization hash is valid
	# ---
	my $this = shift;
	my $init = shift;
	if ($init->{bootloader}) {
		if (! $this->__isValidBootloader($init->{bootloader},
										'object initialization')) {
			return;
		}
	}
	if ($init->{devicepersistency}) {
		if (! $this->__isValidDevPersist($init->{devicepersistency},
										'object initialization')) {
			return;
		}
	}
	if ($init->{filesystem}) {
		if (! $this->__isValidFilesystem($init->{filesystem},
										'object initialization')) {
			return;
		}
	}
	if ($init->{flags}) {
		if (! $this->__isValidFlags($init->{flags},
									'object initialization')) {
			return;
		}
	}
	if ($init->{format}) {
		if (! $this->__isValidFormat($init->{format},
									'object initialization')) {
			return;
		}
	}
	if ($init->{fsreadonly}) {
		if (! $this->__isValidFilesystem($init->{fsreadonly},
										'object initialization')) {
			return;
		}
	}
	if ($init->{fsreadwrite}) {
		if (! $this->__isValidFilesystem($init->{fsreadwrite},
										'object initialization')) {
			return;
		}
	}
	if ($init->{image}) {
		if (! $this->__isValidImage($init->{image},
									'object initialization')) {
			return;
		}
	}
	if ($init->{installboot}) {
		if (! $this->__isValidInstBoot($init->{installboot},
									'object initialization')) {
			return;
		}
	}
	if (! $this -> __checkBools($init) ) {
		return;
	}
	return 1;
}

#==========================================
# __setBoolean
#------------------------------------------
sub __setBoolean {
	# ...
	# Generic code to set the given boolean attribute on the object
	# ---
	my $this     = shift;
	my $settings = shift;
	my $attr   = $settings->{attr};
	my $bVal   = $settings->{value};
	my $caller = $settings->{caller};
	my $kiwi   = $this->{kiwi};
	if (! $attr ) {
		my $msg = 'Internal error __setBoolean called without '
			. 'attribute to set.';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	if (! $caller ) {
		my $msg = 'Internal error __setBoolean called without '
			. 'call origin argument.';
		$kiwi -> info($msg);
		$kiwi -> oops();
	}
	if (! $this -> __isValidBool($bVal) ) {
		my $msg = "$caller: unrecognized argument expecting "
			. '"true" or "false".';
		$kiwi -> error($msg);
		$kiwi -> failed();
		return;
	}
	if (! $bVal) {
		$this->{$attr} = 'false';
	} else {
		$this->{$attr} = $bVal;
	}
		
	return $this;
}

1;
