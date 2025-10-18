{ lib, config, pkgs, ... }:

{
  imports = [
    ./configuration.nix
  ];

  networking.hostName = "thor";

  hardware.graphics.extraPackages =  with pkgs; [
    rocmPackages.clr.icd # OpenCL
    pkgs.amdvlk # Vulkan
  ];
  hardware.graphics.extraPackages32 = [ pkgs.driversi686Linux.amdvlk ]; # Vulkan support for 32-bit applications

  environment.variables.ROC_ENABLE_PRE_VEGA = "1"; # Reenable OpenCL on Polaris-based cards above ROCm 4.5
  environment.variables.AMD_VULKAN_ICD = "RADV"; # Force RADV

  services.xserver.videoDrivers = [
    # Free AMD Video Drivers
    "amdgpu"

    # # Propreitary AMD Video Drivers
    # "amdgpu-pro"
  ];
}
