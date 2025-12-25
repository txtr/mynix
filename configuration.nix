{ lib, config, pkgs, ... }:

{
  imports = [
    ./base.nix
  ];

  networking.hostName = "zeus";

  hardware.graphics.extraPackages =  with pkgs; [
    rocmPackages.clr.icd # OpenCL
  ];
  hardware.amdgpu.opencl.enable = true;
  
  environment.variables.ROC_ENABLE_PRE_VEGA = "1"; # Reenable OpenCL on Polaris-based cards above ROCm 4.5
  environment.variables.AMD_VULKAN_ICD = "RADV"; # Force RADV

  services.xserver.videoDrivers = [
    # Free AMD Video Drivers
    "amdgpu"

    # # Propreitary AMD Video Drivers
    # "amdgpu-pro"
  ];

  hardware.amdgpu.overdrive.ppfeaturemask = "0xffffffff";
  hardware.amdgpu.overdrive.enable = true;
  services.lact.enable = true;

  virtualisation.docker.enable = true; # Install Docker
  users.extraGroups.docker.members = [ "txtr" ]; # Allow user to access docker socket
}
