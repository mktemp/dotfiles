import XMonad

main = xmonad defaultConfig {
	modMask = mod1Mask,
	terminal = "st",
	borderWidth = 0
}
