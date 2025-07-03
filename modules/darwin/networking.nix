{ ... }: let
in {
  networking.applicationFirewall.enable = true;
  networking.applicationFirewall.enableStealthMode = true;
  networking.applicationFirewall.allowSigned = true;
  networking.applicationFirewall.allowSignedApp = true;
  networking.applicationFirewall.blockAllIncoming = true;
}
